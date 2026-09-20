const { createApp } = Vue;

const dadosIniciais = [
  {
    id: 1001,
    tipo: 'Iluminação',
    bairro: 'Centro',
    endereco: 'Rua 14 de Julho, próximo à praça',
    descricao: 'Poste permanece apagado durante a noite e reduz a visibilidade no trecho.',
    latitude: -20.4633,
    longitude: -54.6155,
    dataHora: '2026-09-16T19:20:00',
    status: 'Em análise',
    imagem: ''
  },
  {
    id: 1002,
    tipo: 'Buraco',
    bairro: 'Centro',
    endereco: 'Cruzamento da Rua Dom Aquino com via secundária',
    descricao: 'Buraco de tamanho médio próximo à faixa de rolamento, com aumento após chuvas.',
    latitude: -20.4598,
    longitude: -54.6132,
    dataHora: '2026-09-18T08:40:00',
    status: 'Aberta',
    imagem: ''
  },
  {
    id: 1003,
    tipo: 'Iluminação',
    bairro: 'Centro',
    endereco: 'Trecho entre duas quadras da região central',
    descricao: 'Nova ocorrência de falta de iluminação na mesma região, registrada por outro morador.',
    latitude: -20.4650,
    longitude: -54.6172,
    dataHora: '2026-09-19T20:10:00',
    status: 'Aberta',
    imagem: ''
  },
  {
    id: 1004,
    tipo: 'Alagamento',
    bairro: 'Jardim dos Estados',
    endereco: 'Avenida principal, próximo ao ponto de ônibus',
    descricao: 'Acúmulo de água durante chuva forte, dificultando a passagem de pedestres.',
    latitude: -20.4521,
    longitude: -54.5907,
    dataHora: '2026-09-14T17:35:00',
    status: 'Resolvida',
    imagem: ''
  }
];

createApp({
  data() {
    return {
      ocorrencias: [],
      form: {
        tipo: '',
        bairro: '',
        endereco: '',
        descricao: '',
        latitude: null,
        longitude: null,
        imagem: ''
      },
      filtros: { tipo: '', bairro: '', status: '', periodo: '' },
      mensagem: '',
      loginAberto: false,
      adminAutenticado: false,
      login: { usuario: '', senha: '' },
      erroLogin: '',
      mapa: null,
      marcadores: []
    };
  },
  computed: {
    tiposDisponiveis() {
      return [...new Set(this.ocorrencias.map(o => o.tipo))].sort();
    },
    ocorrenciasFiltradas() {
      const agora = new Date();
      return [...this.ocorrencias]
        .filter(item => !this.filtros.tipo || item.tipo === this.filtros.tipo)
        .filter(item => !this.filtros.status || item.status === this.filtros.status)
        .filter(item => !this.filtros.bairro || item.bairro.toLowerCase().includes(this.filtros.bairro.toLowerCase()))
        .filter(item => {
          if (!this.filtros.periodo) return true;
          const dias = Number(this.filtros.periodo);
          const data = new Date(item.dataHora);
          return (agora - data) <= dias * 24 * 60 * 60 * 1000;
        })
        .sort((a, b) => new Date(b.dataHora) - new Date(a.dataHora));
    },
    gruposRecorrentes() {
      const grupos = new Map();
      this.ocorrencias.forEach(item => {
        const chave = `${item.tipo.toLowerCase()}|${item.bairro.toLowerCase()}`;
        const atual = grupos.get(chave) || { chave, tipo: item.tipo, bairro: item.bairro, quantidade: 0 };
        atual.quantidade += 1;
        grupos.set(chave, atual);
      });
      return [...grupos.values()].filter(g => g.quantidade >= 2).sort((a, b) => b.quantidade - a.quantidade);
    }
  },
  mounted() {
    const salvo = localStorage.getItem('mui_ocorrencias');
    this.ocorrencias = salvo ? JSON.parse(salvo) : dadosIniciais;
    this.adminAutenticado = sessionStorage.getItem('mui_admin') === '1';
    this.$nextTick(() => {
      this.inicializarMapa();
      this.atualizarMapa();
    });
  },
  watch: {
    ocorrencias: {
      deep: true,
      handler(novoValor) {
        localStorage.setItem('mui_ocorrencias', JSON.stringify(novoValor));
        this.$nextTick(this.atualizarMapa);
      }
    }
  },
  methods: {
    totalPorStatus(status) {
      return this.ocorrencias.filter(o => o.status === status).length;
    },
    salvarOcorrencia() {
      if (!this.form.tipo || !this.form.bairro || !this.form.endereco || !this.form.descricao) return;
      const id = Date.now().toString().slice(-8);
      const coords = this.coordenadasSeguras(this.form.latitude, this.form.longitude);
      this.ocorrencias.push({
        id,
        tipo: this.form.tipo,
        bairro: this.form.bairro,
        endereco: this.form.endereco,
        descricao: this.form.descricao,
        latitude: coords.lat,
        longitude: coords.lng,
        dataHora: new Date().toISOString(),
        status: 'Aberta',
        imagem: this.form.imagem
      });
      this.mensagem = `Ocorrência registrada com sucesso. Protocolo #${id}.`;
      this.limparFormulario(false);
      setTimeout(() => { this.mensagem = ''; }, 4500);
    },
    limparFormulario(limparMensagem = true) {
      this.form = { tipo: '', bairro: '', endereco: '', descricao: '', latitude: null, longitude: null, imagem: '' };
      const input = document.getElementById('imagem');
      if (input) input.value = '';
      if (limparMensagem) this.mensagem = '';
    },
    selecionarImagem(event) {
      const arquivo = event.target.files?.[0];
      if (!arquivo) return;
      if (arquivo.size > 1.5 * 1024 * 1024) {
        alert('Para este MVP, utilize uma imagem com até 1,5 MB.');
        event.target.value = '';
        return;
      }
      const leitor = new FileReader();
      leitor.onload = () => { this.form.imagem = leitor.result; };
      leitor.readAsDataURL(arquivo);
    },
    formatarData(data) {
      return new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short', timeStyle: 'short' }).format(new Date(data));
    },
    statusClass(status) {
      if (status === 'Resolvida') return 'status-done';
      if (status === 'Em análise') return 'status-review';
      return 'status-open';
    },
    limparFiltros() {
      this.filtros = { tipo: '', bairro: '', status: '', periodo: '' };
    },
    abrirLogin() {
      this.loginAberto = true;
      this.erroLogin = '';
    },
    autenticar() {
      if (this.login.usuario === 'admin' && this.login.senha === 'memoria2026') {
        this.adminAutenticado = true;
        sessionStorage.setItem('mui_admin', '1');
        this.erroLogin = '';
        this.login = { usuario: '', senha: '' };
        this.loginAberto = false;
      } else {
        this.erroLogin = 'Usuário ou senha inválidos para a demonstração.';
      }
    },
    sairAdmin() {
      this.adminAutenticado = false;
      sessionStorage.removeItem('mui_admin');
      this.loginAberto = false;
    },
    atualizarStatus(id, novoStatus) {
      const item = this.ocorrencias.find(o => String(o.id) === String(id));
      if (item) item.status = novoStatus;
    },
    coordenadasSeguras(lat, lng) {
      const latNum = Number(lat);
      const lngNum = Number(lng);
      if (Number.isFinite(latNum) && Number.isFinite(lngNum) && latNum >= -90 && latNum <= 90 && lngNum >= -180 && lngNum <= 180) {
        return { lat: latNum, lng: lngNum };
      }
      const jitter = () => (Math.random() - .5) * .035;
      return { lat: -20.4697 + jitter(), lng: -54.6201 + jitter() };
    },
    inicializarMapa() {
      if (!window.L || this.mapa) return;
      this.mapa = L.map('map', { scrollWheelZoom: false }).setView([-20.4697, -54.6201], 12);
      L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19,
        attribution: '&copy; OpenStreetMap contributors'
      }).addTo(this.mapa);
    },
    atualizarMapa() {
      if (!this.mapa || !window.L) return;
      this.marcadores.forEach(m => m.remove());
      this.marcadores = [];
      const limites = [];
      this.ocorrencias.forEach(item => {
        const coords = this.coordenadasSeguras(item.latitude, item.longitude);
        item.latitude = coords.lat;
        item.longitude = coords.lng;
        const marcador = L.marker([coords.lat, coords.lng])
          .addTo(this.mapa)
          .bindPopup(`<strong>${this.escapeHtml(item.tipo)}</strong><br>${this.escapeHtml(item.bairro)}<br><small>${this.escapeHtml(item.status)}</small>`);
        this.marcadores.push(marcador);
        limites.push([coords.lat, coords.lng]);
      });
      if (limites.length > 1) this.mapa.fitBounds(limites, { padding: [35, 35], maxZoom: 14 });
      else if (limites.length === 1) this.mapa.setView(limites[0], 14);
    },
    escapeHtml(valor) {
      return String(valor)
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#039;');
    }
  }
}).mount('#app');
