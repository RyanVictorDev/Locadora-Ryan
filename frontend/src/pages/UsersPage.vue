<template>
  <q-page padding class="backStyle">
    <div class="main">
      <div class="row items-center q-mx-auto text-h5">
        <div class="text-weight-bold q-mr-lg">
          Usuários
          <q-btn push color="teal-10" label="Cadastrar" class="q-ml-sm" @click="openRegisterDialog"/>
        </div>

        <q-form @submit="getRows(srch)" class="q-ml-sm col" input-style="min-width: 100%">
          <q-input v-model="srch" label="Pesquisar..." class="q-ml-sm col" input-style="min-width: 100%">
            <template v-slot:append>
              <q-icon v-if="srch !== ''" name="close" @click="srch = '', getRows(srch)" class="cursor-pointer" />
            </template>

            <template v-slot:after>
              <q-btn @click="getRows(srch)" round dense flat icon="search" />
            </template>
          </q-input>
        </q-form>
      </div>

      <TableComponent
        :title="title"
        :rows="sortedRows"
        :columns="columns"
        :icons="icons"
        @action="handleAction"
        @sort="handleSort"
      />

      <div class="row justify-center q-my-md">
        <q-btn
          :disable="page.value <= 0"
          label="Página Anterior"
          @click="prevPage"
          class="q-mx-sm"
        />
        <q-btn
          label="Próxima Página"
          @click="nextPage"
          class="q-mx-sm"
        />
      </div>

      <q-dialog v-model="dialogs.register.visible" persistent>
        <q-card class="widhtModal radios">
          <q-card-section class="row items-center">
            <q-avatar icon="add" color="teal-10" text-color="white" />
            <span class="q-ml-sm">Cadastrar novo usuário</span>
          </q-card-section>

          <q-card-section>
            <q-form @submit="registerAction" class="q-gutter-md q-my-auto">
              <q-input v-model="userToCreate.name" label="Nome do usuário" filled lazy-rules :rules="[val => val && val.length > 3 || 'É nescessário ter mais de três caracteres']"/>
              <q-input v-model="userToCreate.email" label="Email" filled lazy-rules :rules="[val => !!val || 'Email é obrigatório', val => /^.+@gmail.com$/.test(val) || 'Email inválido']"/>
              <q-input v-model="userToCreate.password" label="Senha" type="password" filled lazy-rules :rules="[val => val && val.length > 3 || 'É nescessário ter mais de três caracteres']"/>

              <div class="q-gutter-sm q-px-auto">
                <q-radio v-model="userToCreate.role" checked-icon="task_alt" unchecked-icon="panorama_fish_eye" val="ADMIN" label="Editor" />
                <q-radio v-model="userToCreate.role" checked-icon="task_alt" unchecked-icon="panorama_fish_eye" val="USER" label="Leitor" />
              </div>

              <q-card-actions align="right">
                <q-btn flat label="Cancelar" color="primary" @click="dialogs.register.visible = false" />
                <q-btn flat label="Salvar" type="submit" color="primary"/>
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
              <span class="q-ml-sm text-h6">Detalhes do usuário {{ dialogs.view.row.name }}</span>
            </div>

            <div class="q-ml-sm ">
              <div class="column q-mt-md">
                <span class="q-ml-sm col"><q-icon name="key"/> Id: {{ userInfor.id }}</span>
                <span class="q-ml-sm col"><q-icon name="person"/> Nome: {{ userInfor.name }}</span>
                <span class="q-ml-sm col"><q-icon name="insert_drive_file"/> Cargo: {{ userInfor.role }}</span>
              </div>
            </div>
          </q-card-section>

          <q-card-actions align="right">
            <q-btn flat label="Fechar" color="primary" @click="dialogs.view.visible = false" />
          </q-card-actions>
        </q-card>
      </q-dialog>

      <q-dialog v-model="dialogs.edit.visible" persistent>
        <q-card class="radios">
          <q-card-section class="row items-center">
            <q-avatar icon="edit" color="green" text-color="white" />
            <span class="q-ml-sm">Você tem certeza que deseja editar o usuário {{ dialogs.edit.row.name }}?</span>
          </q-card-section>

          <q-card-section>
            <q-form @submit="performEditAction" class="q-gutter-md q-my-auto">
              <q-input v-model="userInfor.name" label="Nome do usuário" filled lazy-rules :rules="[val => val && val.length > 3 || 'É nescessário ter mais de três caracteres']"/>
              <q-input v-model="userInfor.email" label="Email" filled lazy-rules :rules="[val => !!val || 'Email é obrigatório', val => /^.+@gmail.com$/.test(val) || 'Email inválido']"/>

              <div class="q-gutter-sm q-px-auto">
                <q-radio v-model="userInfor.role" checked-icon="task_alt" unchecked-icon="panorama_fish_eye" val="ADMIN" label="Editor" />
                <q-radio v-model="userInfor.role" checked-icon="task_alt" unchecked-icon="panorama_fish_eye" val="USER" label="Leitor" />
              </div>

              <q-card-actions align="right">
                <q-btn flat label="Cancelar" color="primary" @click="dialogs.edit.visible = false" />
                <q-btn flat label="Salvar" type="submit" color="primary"/>
              </q-card-actions>
            </q-form>
          </q-card-section>
        </q-card>
      </q-dialog>
    </div>
  </q-page>
</template>

<script setup>
import { useQuasar } from 'quasar';
import { ref, onMounted, computed } from 'vue';
import TableComponent from 'src/components/TableComponent.vue';
import { api } from 'src/boot/axios';

defineOptions({
  name: 'UsersPage',
});

onMounted(() => {
  getRows();

  if (role.value === 'USER') {
    icons.value = ['visibility'];
  } else if (role.value === 'ADMIN') {
    icons.value = ['visibility', 'edit', 'delete'];
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
  { name: 'name', required: true, label: 'Nome do usuário', align: 'center', field: row => row.name, format: val => `${val}`, sortable: true },
  { name: 'role', align: 'center', label: 'Permissão', field: row => traduzirRole(row.role), sortable: true },
  { name: 'actions', align: 'center', label: 'Ações', field: 'actions', sortable: true },
]

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
  api.get('/user', { params: { search: srch, page: page.value } })
    .then(response => {
      rows.value = response.data.content;
      console.log(response.data)
    })
    .catch(error => {
      console.error("Erro ao obter dados:", error);
    });
};

const traduzirRole = (role) => {
  switch (role) {
    case 'ADMIN':
      return 'Editor';

    case 'USER':
      return 'Leitor';
  }
};

const dialogs = ref({
  register: {
    visible: false,
    row: {
      name: ''
    }
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
const icons = ref({});

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

const openRegisterDialog = () => {
  dialogs.value.register.visible = true;
};

const userToCreate = ref({
  name: '',
  email: '',
  password: '',
  role: ''
});

const createRow = (userToCreate) => {
  api.post('/user', userToCreate)
    .then(response => {
      console.log("Sucesso ao criar novo usuário", response);
      dialogs.value.register.visible = false;
      showNotification('positive', "Usuário criado com sucesso!");
      getRows();
    })
    .catch(error => {
      if (error.response.status == 403) {
        showNotification('negative', "Você não tem permissao!");
      } else {
        showNotification('negative', error.response.data.error);
      }

      console.log("Erro ao criar usuário", error.response.status);
    });
};

const registerAction = () => {
  createRow(userToCreate.value);
  console.log(userToCreate);
};

const userInfor = ref([]);

const showMore = (id) => {
  api.get('/user/' + id)
    .then(response => {
      userInfor.value = response.data;
      showNotification('positive', "Detalhes obtidos com sucesso!");
    })
    .catch(error => {
      showNotification('negative', "Erro ao obter detalhes do usuario!");
      console.error("Erro ao obter detalhes do usuario:", error);
    });
};

const editRow = (userInfor) => {
  api.put('/user/' + userInfor.id, userInfor)
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
        showNotification('negative', error.response.data.error);
      }

      console.log("Erro ao editar usuário", error.response.status);
    })
};

const performEditAction = () => {
  editRow(userInfor.value);
};
</script>

<style scoped>
  .radios{
    border-radius: 20px;
  }
</style>
