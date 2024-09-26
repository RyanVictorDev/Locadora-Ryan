
import { api } from 'src/boot/axios';

const getRows = (srch = '') => {
  api.get('/publisher', { params: { search: srch } })
    .then(response => {
      if (Array.isArray(response.data)) {
        rows.value = response.data;
      } else {
        console.error('A resposta da API não é um array:', response.data);
        rows.value = [];
      }
      console.log('Resposta da API:', response.data);
    })
    .catch(error => {
      showNotification('negative', "Erro ao obter dados!");
      console.error("Erro ao obter dados:", error);
    });
}

const createRow = (publisherToCreate) => {
  api.post('/publisher', publisherToCreate)
  .then(response => {
    dialogs.value.register.visible = false;
    showNotification('positive', "Criado com sucesso!");
    getRows();
  })
  .catch(error => {
    if (error.response.status == 403) {
        showNotification('negative', "Você não tem permissao!");
      } else {
        showNotification('negative', "Erro ao criar editora!");
      }

      console.log("Erro ao criar editora", error.response.status);
    });
};
