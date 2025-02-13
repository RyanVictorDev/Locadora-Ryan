import { boot } from 'quasar/wrappers';
import axios from 'axios';

const api = axios.create({
  baseURL: import.meta.env.VITE_BASE_URL,
  headers: {
    "Content-Type": "application/json"
  }
});

const token = localStorage.getItem('authToken');
if (token) {
  api.defaults.headers.common['Authorization'] = `Bearer ${token}`;
}

const authenticate = (username, password) => {
  return api.post('/auth/login', {
    email: username,
    password: password
  })
  .then(response => {
    const token = response.data.token;
    const role = response.data.role;
    if (token) {
      localStorage.setItem('authToken', token);
      localStorage.setItem('role', role);
      api.defaults.headers.common['Authorization'] = `Bearer ${token}`;
    }
  })
  .catch(error => {
    console.error('Erro na autenticação:', error.response ? error.response.data : error.message);
    throw error;
  });
}

export default boot(({ app }) => {
  app.config.globalProperties.$axios = axios;
  app.config.globalProperties.$api = api;
  app.config.globalProperties.$authenticate = authenticate;
});

export { api, authenticate };
