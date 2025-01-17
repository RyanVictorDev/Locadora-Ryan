<template>
  <q-page padding class="backStyle">
    <div class="main radios">
      <div class="row items-center q-mx-auto text-h5">
        <div class="text-weight-bold q-mr-lg">
          Editoras
          <q-btn v-if="isAdmin" push color="teal-10" label="Cadastrar" class="q-ml-sm" @click="openRegisterDialog" itemid="registerBtn"/>
        </div>

        <q-form @submit="getRows(srch)" class="q-ml-sm col" input-style="min-width: 100%">
          <q-input v-model="srch" label="Pesquisar..." class="q-ml-sm col" input-style="min-width: 100%" itemid="searchInput">
            <template v-slot:append>
              <q-icon v-if="srch !== ''" name="close" @click="srch = '', getRows(srch)" class="cursor-pointer" itemid="closeSearchBtn"/>
            </template>

            <template v-slot:after>
              <q-btn round dense flat icon="search" @click="getRows(srch)" itemid="searchBtn"/>
            </template>
          </q-input>
        </q-form>
      </div>

      <TableComponent
        :title="title"
        :rows="sortedRows"
        :columns="columns"
        :icons="icons"
        :iconsDescription="iconsDescription"
        @action="handleAction"
        @sort="handleSort"
      />

      <div class="row justify-center q-my-md">
        <q-btn
          :disable="page.value <= 0"
          icon="chevron_left"
          @click="prevPage"
          class="q-mx-sm"
        />
        <q-btn
          icon="chevron_right"
          @click="nextPage"
          class="q-mx-sm"
        />
      </div>

      <q-dialog v-model="dialogs.register.visible" persistent>
        <q-card class="widhtModal radios">
          <q-card-section class="row items-center">
            <q-avatar icon="add" color="teal-10" text-color="white" />
            <span class="q-ml-sm">Cadastrar Nova Editora</span>
          </q-card-section>

          <q-card-section>
            <q-form @submit="registerAction" class="q-gutter-md q-my-auto">
              <q-input v-model="publisherToCreate.name" label="Nome da Editora" filled lazy-rules :rules="[val => val && val.length > 3 || 'É nescessário ter mais de três caracteres']" itemid="publisherNameInput"/>
              <q-input v-model="publisherToCreate.email" label="Email" filled lazy-rules :rules="[val => !!val || 'Email é obrigatório', val => /^.+@gmail.com$/.test(val) || 'Email inválido']" itemid="publisherEmailInput"/>
              <q-input v-model="publisherToCreate.telephone" label="Telefone" mask="(##) #####-####" fill-mask filled lazy-rules :rules="[val => val && val.length > 10 || 'Adicione um número válido']" itemid="publisherPhoneInput"/>
              <q-input v-model="publisherToCreate.site" label="Site" filled lazy-rules itemid="publisherSiteInput"/>

              <q-card-actions align="right">
                <q-btn flat label="Cancelar" color="primary" @click="dialogs.register.visible = false" />
                <q-btn flat label="Salvar" type="submit" color="primary" itemid="saveBtn"/>
              </q-card-actions>
            </q-form>
          </q-card-section>
        </q-card>
      </q-dialog>

      <q-dialog v-model="dialogs.view.visible" persistent>
        <q-card class="radios">
          <q-card-section class="row items-center column">
            <div>
              <q-avatar icon="visibility" color="blue" text-color="white" />
              <span class="q-ml-sm text-h6">Detalhes da editora {{ dialogs.view.row.name }}</span>
            </div>

            <div class="q-ml-lg">
              <div class="row q-mt-md items-center q-gutter-sm">

                <div class="column q-gutter-sm">
                  <q-input v-model="editoraInfor.id" label="Id" filled lazy-rules readonly>
                    <template v-slot:prepend>
                      <q-icon name="key" />
                    </template>
                  </q-input>

                  <q-input v-model="editoraInfor.name" label="Nome" filled lazy-rules readonly>
                    <template v-slot:prepend>
                      <q-icon name="edit" />
                    </template>
                  </q-input>
                </div>

                <div class="column q-gutter-sm">
                  <q-input v-model="editoraInfor.email" label="Email" filled lazy-rules readonly>
                    <template v-slot:prepend>
                      <q-icon name="email" />
                    </template>
                  </q-input>

                  <q-input v-model="editoraInfor.telephone" label="Telefone" filled lazy-rules readonly>
                    <template v-slot:prepend>
                      <q-icon name="phone" />
                    </template>
                  </q-input>
                </div>

                <q-input class="q-mx-auto" v-model="editoraInfor.site" label="Site" filled lazy-rules readonly>
                  <template v-slot:prepend>
                    <q-icon name="language" />
                  </template>
                </q-input>
              </div>
            </div>

          </q-card-section>

          <q-card-actions align="right">
            <q-btn flat label="Fechar" color="primary" @click="dialogs.view.visible = false" itemid="closeBtn"/>
          </q-card-actions>
        </q-card>
      </q-dialog>

      <q-dialog v-model="dialogs.edit.visible" persistent>
        <q-card class="radios">
          <q-card-section class="row items-center">
            <q-avatar icon="edit" color="green" text-color="white" />
            <span class="q-ml-sm">Você tem certeza que deseja editar a editora {{ dialogs.edit.row.name }}?</span>
          </q-card-section>

          <q-card-section>
            <q-form @submit="performEditAction" class="q-gutter-md q-my-auto">
              <q-input v-model="editoraInfor.name" label="Nome da Editora" filled lazy-rules :rules="[val => val && val.length > 3 || 'É nescessário ter mais de três caracteres']" itemid="updateNameInput"/>
              <q-input v-model="editoraInfor.email" label="Email" filled lazy-rules :rules="[val => !!val || 'Email é obrigatório', val => /^.+@gmail.com$/.test(val) || 'Email inválido']" itemid="updateEmailInput"/>
              <q-input v-model="editoraInfor.telephone" label="Telefone" mask="(##) #####-####" fill-mask filled lazy-rules :rules="[val => val && val.length > 10 || 'Adicione um número válido']" itemid="updatePhoneInput"/>
              <q-input v-model="editoraInfor.site" label="Site" filled lazy-rules itemid="updateSiteInput"/>

              <q-card-actions align="right">
                <q-btn flat label="Cancelar" color="primary" @click="dialogs.edit.visible = false" />
                <q-btn flat label="Salvar" type="submit" color="primary" itemid="saveBtn"/>
              </q-card-actions>
            </q-form>
          </q-card-section>
        </q-card>
      </q-dialog>

      <q-dialog v-model="dialogs.delete.visible" persistent>
        <q-card class="radios">
          <q-card-section class="row items-center">
            <q-avatar icon="delete" color="red" text-color="white" />
            <span class="q-ml-sm">Você tem certeza que deseja excluir a editora {{ dialogs.delete.row.name }}?</span>
          </q-card-section>

          <q-card-actions align="right">
            <q-btn flat label="Cancelar" color="primary" @click="dialogs.delete.visible = false"/>
            <q-btn flat label="Excluir" color="primary" @click="performDeleteAction" itemid="saveBtn"/>
          </q-card-actions>
        </q-card>
      </q-dialog>
    </div>
  </q-page>
</template>


<script setup>
import { useQuasar } from 'quasar';
import { ref, onMounted, computed } from 'vue';
import TableComponent from 'src/components/TableComponent.vue';
import { api, authenticate } from 'src/boot/axios';

defineOptions({
  name: 'PublishersPage',
});

onMounted(() => {
    getRows();
  if (role.value === 'USER') {
    icons.value = ['visibility'];
    iconsDescription.value = ['Detalhes'];
    
  } else if (role.value === 'ADMIN') {
    icons.value = ['visibility', 'edit', 'delete'];
    iconsDescription.value = ['Detalhes', 'Editar', 'Deletar']
    isAdmin.value = true;
  }
});

const $q = useQuasar();

const showNotification = (type, msg) => {
  $q.notify({
    type: type,
    message: msg,
    position: 'bottom-right',
    timeout: 3000
  });
};

const columns = [
  { name: 'name', required: true, label: 'Nome da Editora', align: 'center', field: row => row.name, format: val => `${val}`, sortable: true},
  { name: 'actions', align: 'center', label: 'Ações', field: 'actions' },
];

const rows = ref([]);

const srch = ref('');

const sortBy = ref('');
const sortDesc = ref(false);

const page = ref(0)

const prevPage = () => {
  if (page.value > 0) {
    page.value--;
    getRows(srch.value);
  }
};

const nextPage = () => {
  page.value++;
  getRows(srch.value);
};

const getRows = (srch = '') => {
  api.get('/publisher', { params: { search: srch, page: page.value } })
    .then(response => {
      if (Array.isArray(response.data.content)) {
        rows.value = response.data.content;
      } else {
        console.error('A resposta da API não é um array:', response.data);
        rows.value = [];
      }
      console.log('Resposta da API:', response.data);
    })
    .catch(error => {
      console.error("Erro ao obter dados:", error);
    });
}

const handleSort = (colName) => {
  if (sortBy.value === colName) {
    sortDesc.value = !sortDesc.value;
  } else {
    sortBy.value = colName;
    sortDesc.value = false;
  }
};

const sortedRows = computed(() => {
  const sorted = [...rows.value];
  if (sortBy.value) {
    sorted.sort((a, b) => {
      const aVal = typeof a[sortBy.value] === 'string' ? a[sortBy.value].toLowerCase() : a[sortBy.value];
      const bVal = typeof b[sortBy.value] === 'string' ? b[sortBy.value].toLowerCase() : b[sortBy.value];

      if (aVal < bVal) return sortDesc.value ? 1 : -1;
      if (aVal > bVal) return sortDesc.value ? -1 : 1;
      return 0;
    });
  }
  return sorted;
});

const dialogs = ref({
  register: {
    visible: false,
    row: {
      name: ''
    }
  },
  delete: {
    visible: false,
    row: null
  },
  view: {
    visible: false,
    row: null
  },
  edit: {
    visible: false,
    row: null
  }
});

const role = ref(localStorage.getItem('role'))
const isAdmin = ref(false);
const icons = ref({});
const iconsDescription = ref({});

const handleAction = ({ row, icon }) => {
  if (icon === 'delete') {
    dialogs.value.delete.row = row;
    dialogs.value.delete.visible = true;
  } else if (icon === 'visibility') {
    dialogs.value.view.row = row;
    dialogs.value.view.visible = true;
    showMore(row.id);
  } else if (icon === 'edit') {
    dialogs.value.edit.row = row;
    dialogs.value.edit.visible = true;
    showMore(row.id);
  }
};

const publisherToCreate = ref({
  name: '',
  email: '',
  telephone: '',
  site: ''
});

const openRegisterDialog = () => {
  dialogs.value.register.visible = true;
};


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
        const errors = error.response.data;

        for (const [field, message] of Object.entries(errors)) {

          showNotification('negative', message);

        }
      }

      console.log("Erro ao criar editora", error.response.data.error);
    });
};

const registerAction = () => {
  createRow(publisherToCreate.value);
};

const editoraInfor = ref([]);

const showMore = (id) => {
  api.get('/publisher/' + id)
    .then(response => {
      editoraInfor.value = response.data;
      showNotification('positive', "Dados obtidos com sucesso!");
      console.log(editoraInfor.value);
    })
    .catch(error => {
      showNotification('negative', "Erro ao obter detalhes da editora...");
      console.error("Erro ao obter detalhes da editora:", error);
    });
}

const editRow = (editoraInfor) => {
  api.put('/publisher/' + editoraInfor.id, editoraInfor)
    .then(response => {
      showNotification('positive', "Editado com sucesso!");
      dialogs.value.edit.visible = false;
      getRows();
    })
    .catch(error => {
      if (error.response.status == 403) {
        showNotification('negative', "Você não tem permissao!");
      } else {
        const errors = error.response.data;

        for (const [field, message] of Object.entries(errors)) {

          showNotification('negative', message);

        }
      }

      console.log("Erro ao editar editora", error.response.status);
    });
};

const performEditAction = () => {
  editRow(editoraInfor.value);
};

const deleteRow = (id) => {
  api.delete('/publisher/' + id)
    .then(() => {
      rows.value = rows.value.filter(row => row.id !== id);
      dialogs.value.delete.visible = false;
      showNotification('positive', "Excluído com sucesso!");
      getRows();
    })
    .catch(error => {
      if (error.response.status == 403) {
        showNotification('negative', "Você não tem permissao!");
      } else {
        showNotification('negative', error.response.data.error);
      }

      console.log("Erro ao excluir editora", error.response.status);
    });
};

const performDeleteAction = () => {
  const { row } = dialogs.value.delete;
  deleteRow(row.id);
};
</script>


<style scoped>
.whiteFont {
  color: aliceblue;
}
.bgPadrao {
  background-color: #2c3d47;
}
.q-item.q-router-link--active,
.q-item--active {
  color: #00c986;
}
.flex-column {
  display: flex;
  flex-direction: column;
}
.full-height {
  height: 100%;
}
.flex-grow {
  flex-grow: 1;
}
.logout {
  border-radius: 10px;
}
.radios{
  border-radius: 20px;
}
</style>
