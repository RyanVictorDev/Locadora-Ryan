<template>
  <q-page padding class="backStyle">
    <div class="main radios">
      <div class="row items-center q-mx-auto text-h5">
        <div class="text-weight-bold q-mr-lg">
          Usuários
          <q-btn v-if="isAdmin" push color="teal-10" label="Cadastrar" class="q-ml-sm" @click="openRegisterDialog" itemid="cadastrarBtn"/>
        </div>

        <q-form @submit="getRows(srch)" class="q-ml-sm col" input-style="min-width: 100%">
          <q-input v-model="srch" label="Pesquisar..." class="q-ml-sm col" input-style="min-width: 100%" itemid="searchInput">
            <template v-slot:append>
              <q-icon v-if="srch !== ''" name="close" @click="srch = '', getRows(srch)" class="cursor-pointer" itemid="closeSearchBtn"/>
            </template>

            <template v-slot:after>
              <q-btn @click="getRows(srch)" round dense flat icon="search" itemid="searchBtn"/>
            </template>
          </q-input>
        </q-form>


        <!-- <q-btn-dropdown color="teal-9" label="Filtrar" icon="filter_list" itemid="filterBtn">
          <q-list>
            <q-item clickable v-close-popup @click="permissionFilter('ADMIN')" itemid="filterEditorBtn">
              <q-item-section>
                <q-item-label>Editor</q-item-label>
              </q-item-section>
            </q-item>

            <q-item clickable v-close-popup @click="permissionFilter('USER')" itemid="filterLeitorBtn">
              <q-item-section>
                <q-item-label>Leitor</q-item-label>
              </q-item-section>
            </q-item>

            <q-item clickable v-close-popup @click="permissionFilter('')" itemid="filterTodosBtn">
              <q-item-section>
                <q-item-label>Todos</q-item-label>
              </q-item-section>
            </q-item>
          </q-list>
        </q-btn-dropdown> -->
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
            <span class="q-ml-sm">Cadastrar novo usuário</span>
          </q-card-section>

          <q-card-section>
            <q-form @submit="registerAction" class="q-gutter-md q-my-auto">
              <q-input v-model="userToCreate.name" label="Nome do usuário" filled lazy-rules :rules="[val => val && val.length > 3 || 'É nescessário ter mais de três caracteres']" itemid="usernameInput"/>
              <q-input v-model="userToCreate.email" label="Email" filled lazy-rules :rules="[val => !!val || 'Email é obrigatório', val => /^.+@gmail.com$/.test(val) || 'Email inválido']" itemid="emailInput"/>
              <q-input v-model="userToCreate.password" label="Senha" type="password" filled lazy-rules :rules="[val => val && val.length > 3 || 'É nescessário ter mais de três caracteres']" itemid="passwordInput"/>

              <div class="q-gutter-sm q-px-auto">
                <q-radio v-model="userToCreate.role" checked-icon="task_alt" unchecked-icon="panorama_fish_eye" val="ADMIN" label="Editor" :rules="[val => !!val || 'Por favor, selecione uma função']" itemid="roleEditor"/>
                <q-radio v-model="userToCreate.role" checked-icon="task_alt" unchecked-icon="panorama_fish_eye" val="USER" label="Leitor" :rules="[val => !!val || 'Por favor, selecione uma função']" itemid="roleLeitor"/>
              </div>

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
              <span class="q-ml-sm text-h6">Detalhes do usuário {{ dialogs.view.row.name }}</span>
            </div>

            <div class="q-ml-sm">

              <div class="column q-mt-md items-center q-gutter-sm">
                  <q-input v-model="userInfor.id" label="Id do usuário" filled lazy-rules readonly>
                    <template v-slot:prepend>
                      <q-icon name="badge" />
                    </template>
                  </q-input>

                  <q-input v-model="userInfor.name" label="Nome do usuário" filled lazy-rules readonly>
                    <template v-slot:prepend>
                      <q-icon name="person" />
                    </template>
                  </q-input>

                  <q-input v-model="userInfor.role" label="Cargo do usuário" filled lazy-rules readonly>
                    <template v-slot:prepend>
                      <q-icon name="work" />
                    </template>
                  </q-input>
              </div>

            </div>
          </q-card-section>

          <q-card-actions align="right">
            <q-btn flat label="Fechar" color="primary" @click="dialogs.view.visible = false" itemid="cancelBtn"/>
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
              <q-input v-model="userInfor.name" label="Nome do usuário" filled lazy-rules :rules="[val => val && val.length > 3 || 'É nescessário ter mais de três caracteres']" itemid="nameUpdateInput"/>
              <q-input v-model="userInfor.email" label="Email" filled lazy-rules :rules="[val => !!val || 'Email é obrigatório', val => /^.+@gmail.com$/.test(val) || 'Email inválido']" itemid="emailUpdateInput"/>

              <div class="q-gutter-sm q-px-auto">
                <q-radio v-model="userInfor.role" checked-icon="task_alt" unchecked-icon="panorama_fish_eye" val="ADMIN" label="Editor" />
                <q-radio v-model="userInfor.role" checked-icon="task_alt" unchecked-icon="panorama_fish_eye" val="USER" label="Leitor" />
              </div>

              <q-card-actions align="right">
                <q-btn flat label="Cancelar" color="primary" @click="dialogs.edit.visible = false" />
                <q-btn flat label="Salvar" type="submit" color="primary" itemid="saveBtn"/>
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
    iconsDescription.value = ['Detalhes'];

  } else if (role.value === 'ADMIN') {
    icons.value = ['visibility', 'edit'];
    iconsDescription.value = ['Detalhes', 'Editar'];
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
const roleFilter = ref('')
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

const permissionFilter = (permission) => {
  console.log(permission);
  roleFilter.value = permission;
  getRows();
}

const getRows = (srch = '', role = roleFilter.value) => {
  api.get('/user', { params: { search: srch, page: page.value, role: role } })
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
  } else if (icon === 'edit' && row.id !== 1) {
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
      } if (userToCreate.role == ''){
        showNotification('negative', "Adicione uma permissão");
      } else {
        showNotification('negative', error.response.data.error);
      }

      console.log("Erro ao criar usuário", error.response.error);
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
