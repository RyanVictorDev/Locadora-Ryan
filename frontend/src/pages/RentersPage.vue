<template>
  <q-page padding class="backStyle">
    <div class="main radios">
      <div class="row items-center q-mx-auto text-h5">
        <div class="text-weight-bold q-mr-lg">
          Locatários
          <q-btn v-if="isAdmin" push color="teal-10" label="Cadastrar" class="q-ml-sm" @click="openRegister" itemid="registerBtn"/>
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
            <span class="q-ml-sm">Cadastrar Novo locatário</span>
          </q-card-section>

          <q-card-section>
            <q-form @submit="registerAction" class="q-gutter-md q-my-auto">
              <q-input v-model="renterToCreate.name" label="Nome do locatário" filled lazy-rules :rules="[val => val && val.length > 3 || 'É nescessário ter mais de três caracteres']" itemid="renterNameInput"/>
              <q-input v-model="renterToCreate.email" label="Email" filled lazy-rules :rules="[val => !!val || 'Email é obrigatório', val => /^.+@gmail.com$/.test(val) || 'Email inválido']" itemid="renterEmailInput"/>
              <q-input v-model="renterToCreate.telephone" label="Telefone" mask="(##) #####-####" fill-mask filled lazy-rules :rules="[val => val && val.length > 10 || 'Adicione um número válido']" itemid="renterPhoneInput"/>
              <q-input v-model="renterToCreate.address" label="Endereço" filled lazy-rules :rules="[val => val && val.length > 3 || 'É nescessário ter mais de três caracteres']" itemid="renterAdressInput"/>
              <q-input v-model="renterToCreate.cpf" label="Cpf" mask="###.###.###-##" fill-mask filled lazy-rules itemid="renterCpfInput"/>

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
              <span class="q-ml-sm text-h6">Detalhes do locatário {{ dialogs.view.row.name }}</span>
            </div>

            <div class="q-ml-sm">
              <div class="row q-mt-md items-center q-gutter-sm">

                <div class="column q-gutter-sm">
                  <q-input v-model="renterInfor.id" label="Id" filled lazy-rules readonly>
                  <template v-slot:prepend>
                    <q-icon name="key" />
                  </template>
                  </q-input>

                  <q-input v-model="renterInfor.name" label="Nome" filled lazy-rules readonly>
                    <template v-slot:prepend>
                      <q-icon name="person" />
                    </template>
                  </q-input>

                  <q-input v-model="renterInfor.email" label="Email" filled lazy-rules readonly>
                    <template v-slot:prepend>
                      <q-icon name="email" />
                    </template>
                  </q-input>
                </div>

                <div class="column q-gutter-sm">
                  <q-input v-model="renterInfor.telephone" label="Telefone" filled lazy-rules readonly>
                  <template v-slot:prepend>
                    <q-icon name="phone" />
                  </template>
                  </q-input>

                  <q-input v-model="renterInfor.address" label="Endereço" filled lazy-rules readonly>
                    <template v-slot:prepend>
                      <q-icon name="home" />
                    </template>
                  </q-input>

                  <q-input v-model="renterInfor.cpf" label="CPF" filled lazy-rules readonly>
                    <template v-slot:prepend>
                      <q-icon name="insert_drive_file" />
                    </template>
                  </q-input>
                </div>

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
            <span class="q-ml-sm">Você tem certeza que deseja editar o locatário {{ dialogs.edit.row.name }}?</span>
          </q-card-section>

          <q-card-section>
            <q-form @submit="performEditAction" class="q-gutter-md q-my-auto">
              <q-input v-model="renterInfor.name" label="Nome do locatário" filled lazy-rules :rules="[val => val && val.length > 3 || 'É nescessário ter mais de três caracteres']" itemid="updateNameInput"/>
              <q-input v-model="renterInfor.email" label="Email" filled lazy-rules :rules="[val => !!val || 'Email é obrigatório', val => /^.+@gmail.com$/.test(val) || 'Email inválido']" itemid="updateEmailInput"/>
              <q-input v-model="renterInfor.telephone" label="Telefone" mask="(##) #####-####" fill-mask filled lazy-rules :rules="[val => val && val.length > 10 || 'Adicione um número válido']" itemid="updatePhoneInput"/>
              <q-input v-model="renterInfor.address" label="Endereço" filled lazy-rules :rules="[val => val && val.length > 3 || 'É nescessário ter mais de três caracteres']" itemid="updateAdressInput"/>
              <q-input v-model="renterInfor.cpf" label="CPF" mask="###.###.###-##" fill-mask filled lazy-rules itemid="updateCpfInput"/>

              <q-card-actions align="right">
                <q-btn flat label="Cancelar" color="primary" @click="dialogs.edit.visible = false"/>
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
            <span class="q-ml-sm">Você tem certeza que deseja excluir o locatário {{ dialogs.delete.row.name }}?</span>
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
  name: 'RentersPage',
});

onMounted(() => {
  getRows();

  if (role.value === 'USER') {
    icons.value = ['visibility'];
    iconsDescription.value = ['Detalhes'];

  } else if (role.value === 'ADMIN') {
    icons.value = ['visibility', 'edit', 'delete'];
    iconsDescription.value = ['Detalhes', 'Editar', 'Deletar'];
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
  { name: 'name', required: true, label: 'Nome do locatário', align: 'center', field: row => row.name, format: val => `${val}`, sortable: true},
  { name: 'email', align: 'center', label: 'Email', field: 'email', sortable: true},
  { name: 'telephone', align: 'center', label: 'Telefone', field: 'telephone', sortable: true},
  { name: 'actions', align: 'center', label: 'Ações', field: 'actions'}
]

const rows = ref([]);

const srch = ref('');

const sortBy = ref('');
const sortDesc = ref(false);

const sortedRows = computed(() => {
  if (!sortBy.value) return rows.value;
  return [...rows.value].sort((a, b) => {
    const aValue = a[sortBy.value];
    const bValue = b[sortBy.value];
    if (aValue < bValue) return sortDesc.value ? 1 : -1;
    if (aValue > bValue) return sortDesc.value ? -1 : 1;
    return 0;
  });
});

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
  api.get('/renter', { params: { search: srch, page: page.value } })
    .then(response => {
      if (Array.isArray(response.data.content)) {
        rows.value = response.data.content;
      } else {
        console.error('A resposta da API não é um array:', response.data);
        rows.value = response.data;
      }
    })
    .catch(error => {
      console.error("Erro ao obter dados:", error);
    });
};

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

const openRegister = () => {
  dialogs.value.register.visible = true;
}

const renterToCreate = ref({
  name: '',
  email: '',
  telephone: '',
  address: '',
  cpf: ''
});


const createRow = (renterToCreate) => {
  api.post('/renter', renterToCreate)
  .then(response => {
    console.log("Sucesso ao criar novo locatário", response);
    dialogs.value.register.visible = false;
    showNotification('positive', "Sucesso ao criar novo locatário!");
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

      console.log("Erro ao criar locatário", error.response.data);
  })
};

const handleSort = (column) => {
  if (sortBy.value === column) {
    sortDesc.value = !sortDesc.value;
  } else {
    sortBy.value = column;
    sortDesc.value = false;
  }
};

const registerAction = () => {
  createRow(renterToCreate.value);
};

const renterInfor = ref([]);

const showMore = (id) => {
  api.get('/renter/' + id)
    .then(response => {
      renterInfor.value = response.data;
      console.log(renterInfor.value);
      showNotification('positive', "Detalhes obtidos com sucesso!");
    })
    .catch(error => {
      showNotification('negative', "Erro ao obter detalhes do locatário!");
      console.error("Erro ao obter detalhes do locatário:", error);
    });
};

const editRow = (renterInfor) => {
  api.put('/renter/' + renterInfor.id, renterInfor)
    .then(response => {
      console.log("Sucesso ao editar", response);
      showNotification('positive', "Sucesso ao editar!");
      getRows();
      dialogs.value.edit.visible = false;
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

      console.log("Erro ao editar locatário", error.response.status);
    })
};

const performEditAction = () => {
  editRow(renterInfor.value);
};

const deleteRow = (id) => {
  api.delete('/renter/' + id)
    .then(() => {
      rows.value = rows.value.filter(row => row.id !== id);
      dialogs.value.delete.visible = false;
      console.log("Locatário excluído com sucesso");
      showNotification('positive', "Locatário excluído com sucesso!");
      getRows();
    })
    .catch(error => {
      if (error.response.status == 403) {
        showNotification('negative', "Você não tem permissao!");
      } else {
        showNotification('negative', error.response.data.error);
      }

      console.log("Erro ao deletar locatário", error.response.status);
    });
};

const performDeleteAction = () => {
  const { row } = dialogs.value.delete;
  deleteRow(row.id);
};
</script>

<style scoped>
  .radios{
    border-radius: 20px;
  }
</style>
