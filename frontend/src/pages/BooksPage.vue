<template>
  <q-page padding class="backStyle">
    <div class="main radios">
      <div class="row items-center q-mx-auto text-h5">
        <div class="text-weight-bold q-mr-lg">
          Livros
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

      <q-dialog v-model="dialogs.register.visible" persistent class="q-pa-lg">
        <q-card class="widhtModal radios">
          <q-card-section class="row items-center text-h5">
            <q-avatar icon="add" color="teal-10" text-color="white"/>
            <span class="q-ml-sm">Cadastrar Novo Livro</span>
          </q-card-section>

          <q-card-section>
            <q-form @submit.prevent="registerAction" class="q-gutter-none q-my-auto">
              <q-input v-model="bookToCreate.name" label="Título do livro" filled lazy-rules :rules="[val => val && val.length > 4 || 'É necessário ter mais de quatro caracteres']" itemid="bookNameInput"/>
              <q-input v-model="bookToCreate.author" label="Autor" filled lazy-rules :rules="[val => val && val.length > 3 || 'É necessário ter mais de três caracteres']" itemid="bookAuthInput"/>
              <q-input v-model="bookToCreate.totalQuantity" label="Quantidade" type="number" filled lazy-rules :rules="[val => val > 0 || 'É necessário ter pelo menos 1']" itemid="bookQuantityInput"/>
              <q-input v-model="bookToCreate.launchDate" label="Data de lançamento" type="date" mask="####-##-##" fill-mask filled lazy-rules :rules="[val => val && val.length >= 6 || 'Adicione uma data válida']" :max="today" itemid="bookLaunchDateInput"/>

              <q-select
                itemid="publisherInput"
                filled
                v-model="selectedPublisher"
                use-input
                hide-selected
                fill-input
                input-debounce="0"
                :options="publishers"
                option-label="name"
                @filter="publishersFilter"
                @update:model-value="onItemClickRegister(selectedPublisher, bookToCreate)"
                label="Editora"
                aria-required="true"
              >
                <template v-slot:no-option>
                  <q-item>
                    <q-item-section class="text-grey">
                      No results
                    </q-item-section>
                  </q-item>
                </template>
              </q-select>

              <p>id da editora: <span class="text-bold">{{ bookToCreate.publisherId }}</span></p>

              <q-card-actions align="right">
                <q-btn flat label="Cancelar" color="primary" @click="dialogs.register.visible = false"/>
                <q-btn flat label="Salvar" type="submit" color="primary" itemid="saveBtn"/>
              </q-card-actions>
            </q-form>
          </q-card-section>
        </q-card>
      </q-dialog>

      <q-dialog v-model="dialogs.rent.visible" persistent>
        <q-card class="radios">
          <q-card-section class="row items-center">
            <q-avatar icon="bookmark" color="blue" text-color="white"/>
            <span class="q-ml-sm">Alugar o livro <span class="text-bold">{{dialogs.rent.row.name }}</span>?</span>
          </q-card-section>

          <q-card-section>
            <q-form @submit.prevent="rentAction(dialogs.rent.row.id)" class="q-gutter-md q-my-auto">
              <q-input v-model="bookToRent.deadLine" label="Devolução" type="date" mask="####-##-##" fill-mask filled lazy-rules :min="today" :max="maxReturnDate" itemid="deadLineInput"/>

              <q-select
                itemid="renterInput"
                filled
                v-model="selectedRenter"
                use-input
                hide-selected
                fill-input
                input-debounce="0"
                :options="renters"
                option-label="name"
                @filter="rentersFilter"
                @update:model-value="onItemClickRent"
                label="Locatário"
              >
                <template v-slot:no-option>
                  <q-item>
                    <q-item-section class="text-grey">
                      No results
                    </q-item-section>
                  </q-item>
                </template>
              </q-select>

              <p>id do locatário: <span class="text-bold">{{ renterId }}</span></p>

              <q-card-actions align="right">
                <q-btn flat label="Cancelar" color="primary" @click="dialogs.rent.visible = false"/>
                <q-btn flat label="Salvar" type="submit" color="primary" itemid="saveBtn"/>
              </q-card-actions>
            </q-form>
          </q-card-section>
        </q-card>
      </q-dialog>

      <q-dialog v-model="dialogs.edit.visible" persistent>
        <q-card class="radios">
          <q-card-section class="row items-center">
            <q-avatar icon="edit" color="green" text-color="white"/>
            <span class="q-ml-sm">Você tem certeza que deseja editar o livro {{ dialogs.edit.row.name }}?</span>
          </q-card-section>

          <q-card-section>
            <q-form @submit.prevent="performEditAction(bookInforEdit), showMore(dialogs.edit.row.id)" class="q-gutter-md q-my-auto">
              <q-input v-model="bookInforEdit.name" label="Título do livro" filled lazy-rules itemid="updateNameInput"/>
              <q-input v-model="bookInforEdit.author" label="Autor" filled lazy-rules itemid="updateAuthInput"/>
              <q-input v-model="bookInforEdit.totalQuantity" label="Estoque" filled lazy-rules itemid="updateQuantityInput"/>
              <q-input v-model="bookInforEdit.launchDate" label="Data de lançamento" type="date" filled lazy-rules itemid="updateLaunchDateInput"/>
              <q-input v-model="bookInforEdit.publisherId" label="Id da editora" filled lazy-rules readonly/>

              <q-select
                filled
                v-model="selectedPublisher"
                use-input
                hide-selected
                fill-input
                input-debounce="0"
                :options="publishers"
                option-label="name"
                @filter="publishersFilter"
                @update:model-value="onItemClickEdit(selectedPublisher, bookInforEdit)"
                label="Nova editora"
              >
                <template v-slot:no-option>
                  <q-item>
                    <q-item-section class="text-grey">
                      No results
                    </q-item-section>
                  </q-item>
                </template>
              </q-select>

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
            <q-avatar icon="delete" color="red" text-color="white"/>
            <span class="q-ml-sm">Você tem certeza que deseja excluir o livro {{ dialogs.delete.row.name }}?</span>
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
  name: 'BooksPage',
});

onMounted(() => {
    getRows();
    getPublishers();
    getRents();

  if (role.value === 'USER') {
    icons.value = [];
  } else if (role.value === 'ADMIN') {
    icons.value = ['bookmark', 'edit', 'delete'];
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
  { name: 'title', required: true, label: 'Título', align: 'center', field: row => row.name, format: val => `${val}`, sortable: true},
  { name: 'author', align: 'center', label: 'Autor', field: 'author', sortable: true},
  { name: 'totalQuantity', align: 'center', label: 'Disponíveis', field: 'totalQuantity', sortable: true},
  { name: 'totalInUse', align: 'center', label: 'Alugados', field: 'totalInUse', sortable: true},
  { name: 'actions', align: 'center', label: 'Ações', field: 'actions'},
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
  api.get('/book', { params: { search: srch, page: page.value } })
    .then(response => {
      if (Array.isArray(response.data.content)) {
        rows.value = response.data.content;
        console.log(response.data)
      } else {
        console.error('A resposta da API não é um array:', response.data);
        rows.value = [];
      }
    })
    .catch(error => {
      console.error("Erro ao obter dados:", error);
    });
};

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
  },
  delete: {
    visible: false,
    row: null
  },
  rent: {
    visible: false,
    row: null
  },
  edit: {
    visible: false,
    row: null
  }
});

const role = ref(localStorage.getItem('role'));
const isAdmin = ref(false);
const icons = ref({});

const handleAction = ({ row, icon }) => {
  if (icon === 'delete') {
    dialogs.value.delete.row = row;
    dialogs.value.delete.visible = true;
  } else if (icon === 'bookmark') {
    dialogs.value.rent.row = row;
    dialogs.value.rent.visible = true;
    showMore(row.id);
  } else if (icon === 'edit') {
    dialogs.value.edit.row = row;
    dialogs.value.edit.visible = true;
    showMore(row.id);
  }
};

const today = new Date().toISOString().split('T')[0];

const bookToCreate = ref({
  name: '',
  author: '',
  totalQuantity: '',
  launchDate: '',
  publisherId: ''
});

const onItemClickRegister = (publisherItem, bookToCreate) => {
  bookToCreate.publisherId = publisherItem.id;
}

const openRegisterDialog = () => {
  dialogs.value.register.visible = true;
};

const createRow = (bookToCreate) => {
  api.post('/book', bookToCreate)
    .then(response => {
      console.log("Sucesso ao criar novo livro", response);
      dialogs.value.register.visible = false;
      showNotification('positive', "Livro criado com sucesso!");
      getRows();
    })
    .catch(error => {
      if (error.response.status == 403) {
        showNotification('negative', "Selecione a editora!");
      } else {
        const errors = error.response.data;

        for (const [field, message] of Object.entries(errors)) {

          showNotification('negative', message);

        }
      }

      console.log("Erro ao criar livro", error.response.data.error);
    });
};

const registerAction = () => {
  createRow(bookToCreate.value);
};

const bookInforEdit = ref([]);

const showMore = (id) => {
  api.get('/book/' + id)
    .then(response => {
      const filteredData = {
      id: response.data.id,
      name: response.data.name,
      author: response.data.author,
      totalQuantity: response.data.totalQuantity,
      launchDate: response.data.launchDate,
      publisherId: response.data.publisher.id
    }

    bookInforEdit.value = filteredData;
    console.log(response.data.publisher.id)
    showNotification('positive', "Dados obtidos com sucesso!");
    })
    .catch(error => {
      showNotification('negative', "Erro ao obter detalhes do livro!");
      console.error("Erro ao obter detalhes do livro:", error);
    });
};

const renters = ref([])
const idRenter = ref('')
const renterId = ref('Escolha um locatário')

const getRents = (srch = '') => {
  api.get('/renter', { params: { search: srch } })
  .then(response => {
    renters.value = response.data
  })
  .catch(error => {
    console.log(error)
  })
}

const maxReturnDate = ref(new Date(new Date().setDate(new Date().getDate() + 30)).toISOString().split('T')[0]);

const bookToRent = ref({
  renterId: idRenter,
  bookId: '',
  deadLine: 'Escolha uma data',
});

const onItemClickRent = (rentItem) => {
  renterId.value = rentItem.id;
  idRenter.value = rentItem.id;
}

const rentBook = () => {
  api.post('/rent', bookToRent.value)
    .then(response => {
      console.log("Sucesso ao alugar livro", response);
      dialogs.value.rent.visible = false;
      showNotification('positive', "Sucesso ao alugar livro!");
      getRows();
    })
    .catch(error => {
      if (error.response.status == 403) {
        showNotification('negative', "Você não tem permissao!");
      } else {
        showNotification('negative', error.response.data.error);
      }

      console.log("Erro ao alugar livro", error.response.data.error);
    });
};

const rentAction = (id) => {
  bookToRent.value.bookId = id;
  rentBook(bookToRent.value);
};

const rentersFilter = (val, update, abort) => {
  if (val === '') {
    update(() => {
      getRents();
    });
  } else {
    update(() => {
      const needle = val.toLowerCase();
      renters.value = renters.value.filter(renter =>
        renter.name.toLowerCase().includes(needle)
      );
    });
  }
};

const publishers = ref([])
const publisherId = ref('')

const getPublishers = (srch = '') => {
  api.get('/publisher', { params: { search: srch } })
  .then(response => {
    publishers.value = response.data
  })
  .catch(error => {
    console.log(error)
  })
}

const onItemClickEdit = (publisherItem, bookInforEdit) => {
  bookInforEdit.publisherId = publisherItem.id;
}

const editRow = (bookInfor) => {
  api.put('/book/'+ bookInfor.id, bookInfor)
    .then(response => {
      console.log("Sucesso ao editar", response);
      showNotification('positive', "Sucesso ao editar livro!");
      dialogs.value.edit.visible = false;
      getRows();
    })
    .catch(error => {
      if (error.response.status == 403) {
        showNotification('negative', "Você não tem permissao!");
      } else {
        showNotification('negative', error.response.data.error);
      }

      console.log("Erro ao editar livro", error.response.status);
    });
};

const publishersFilter = (val, update, abort) => {
  if (val === '') {
    update(() => {
      getPublishers();
    });
  } else {
    update(() => {
      const needle = val.toLowerCase();
      publishers.value = publishers.value.filter(publisher =>
        publisher.name.toLowerCase().includes(needle)
      );
    });
  }
};

const onItemClick = (publisherItem) => {
  bookInforEdit.value.publisherId = publisherItem.id;
}

const performEditAction = (bookInforEdit) => {
  editRow(bookInforEdit);
};

const deleteRow = (id) => {
  api.delete('/book/' + id)
    .then(() => {
      rows.value = rows.value.filter(row => row.id !== id);
      dialogs.value.delete.visible = false;
      console.log("Livro excluído com sucesso");
      showNotification('positive', "Livro excluído com sucesso!");
      getRows();
    })
    .catch(error => {
      if (error.response.status == 403) {
        showNotification('negative', "Você não tem permissao!");
      } else {
        showNotification('negative', error.response.data.error);
      }

      console.log("Erro ao deletar livro", error.response.status);
    });
};

const performDeleteAction = () => {
  const { row } = dialogs.value.delete;
  deleteRow(row.id);
};

const onSubmit = () => {
  console.log("Formulário enviado");
};
</script>

<style scoped>
  .radios{
    border-radius: 20px;
  }
</style>
