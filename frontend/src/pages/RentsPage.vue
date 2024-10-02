<template>
  <q-page padding class="backStyle">
    <div class="main">
      <div class="row items-center q-mx-auto text-h5">
        <div class="text-weight-bold q-mr-lg">
          Aluguéis
        </div>
        <q-form @submit.prevent="getRows(srch)" class="q-ml-sm col" input-style="min-width: 100%">
          <q-input v-model="srch" label="Pesquisar..." class="q-ml-sm col" input-style="min-width: 100%">
            <template v-slot:append>
              <q-icon v-if="srch !== ''" name="close" @click="srch = '', getRows(srch)" class="cursor-pointer" />
            </template>

            <template v-slot:after>
              <q-btn round dense flat icon="search" @click="getRows(srch)"/>
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


      <q-dialog v-model="dialogs.rent.visible" persistent>
        <q-card class="radios">
          <q-card-section class="row items-center">
            <q-avatar icon="bookmark_border" color="blue" text-color="white" />
            <span class="q-ml-sm">Devolver o livro "{{ dialogs.rent.row.book.name }}" alugado por {{ dialogs.rent.row.renter.name }}?</span>
          </q-card-section>

          <q-card-actions align="right">
            <q-btn flat label="Fechar" color="primary" @click="dialogs.rent.visible = false" />
            <q-btn flat label="Devolver" color="primary" @click="performDeliveryAction(dialogs.rent.row.id)" />
          </q-card-actions>
        </q-card>
      </q-dialog>

      <q-dialog v-model="dialogs.edit.visible" persistent>
        <q-card class="radios">
          <q-card-section class="row items-center">
            <q-avatar icon="bookmark" color="blue" text-color="white"/>
            <span class="q-ml-sm">Editar o aluguel {{ dialogs.edit.row.book.name }}?</span>
          </q-card-section>

          <q-card-section>
            <q-form @submit.prevent="editAction(dialogs.edit.row.id, rentToEdit)" class="q-gutter-md q-my-auto">
              <q-input v-model="dialogs.edit.row.book.name" label="Título do livro" filled lazy-rules readonly/>
              <q-input v-model="rentToEdit.renterId" label="ID do locatário" filled lazy-rules readonly/>
              <q-input v-model="rentToEdit.deadLine" label="Devolução" type="date" mask="####-##-##" fill-mask filled lazy-rules/>

              <q-select
                filled
                v-model="selectedRenter"
                use-input
                hide-selected
                fill-input
                input-debounce="0"
                :options="renters"
                option-label="name"
                @filter="rentersFilter"
                @update:model-value="onItemClickEdit(selectedRenter, rentToEdit)"
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
  name: 'RentsPage',
});

onMounted(() => {
    getRows();
    getRenters();
    if (role.value === 'USER') {
     icons.value = [];
   } else if (role.value === 'ADMIN') {
      icons.value = ['bookmark_border', 'edit'];
    }
});

const srch = ref('');

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
  { name: 'renter.name', align: 'center', label: 'Locatário', field: row => row.renter.name, sortable: true},
  { name: 'book.name', align: 'center', label: 'Livro', field: row => row.book.name, sortable: true},
  { name: 'rentDate', align: 'center', label: 'Alugado', field: 'rentDate', sortable: true},
  { name: 'deadLine', align: 'center', label: 'Devolução', field: 'deadLine', sortable: true},
  { name: 'status', align: 'center', label: 'Status', field: row => traduzirStatus(row.status), sortable: true},
  { name: 'actions', align: 'center', label: 'Ações', field: 'actions' },
];

const rows = ref([]);
const sortBy = ref('');
const sortDesc = ref(false);

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
  api.get('/rent', { params: { search: srch, page: page.value } })
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
};

const traduzirStatus = (status) => {
  switch (status) {
    case 'RENTED':
      return 'Alugado';

    case 'IN_TIME':
      return 'Devolvido no prazo';

    case 'LATE':
      return 'Atrasado';

    case 'DELIVERED_WITH_DELAY':
      return 'Devolvido fora prazo';
  }
};

const dialogs = ref({
  rent: {
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
  if (icon === 'bookmark_border') {
    dialogs.value.rent.row = row;
    dialogs.value.rent.visible = true;
  } else if (icon === 'edit') {
    dialogs.value.edit.row = row;
    rentToEdit.value.bookId = row.book.id;
    rentToEdit.value.renterId = row.renter.id;
    rentToEdit.value.deadLine = row.deadLine;
    dialogs.value.edit.visible = true;
  }
};

const deliveryBook = (id) => {
  api.put('/rent/' + id)
    .then(response => {
      console.log("Sucesso ao editar", response);
      showNotification('positive', "Sucesso ao devolver!");
      dialogs.value.rent.visible = false;
      getRows();
    })
    .catch(error => {
      if (error.response.status == 400) {
        console.log("Erro ao editar", error)
        showNotification('negative', "Livro já devolvido!");
      } else {
        console.log("Erro ao editar", error)
        showNotification('negative', "Erro ao devolver!");
      }
    });
};

const performDeliveryAction = (id) => {
  deliveryBook(id);
  console.log(id);
};

const renters = ref([]);

const getRenters = (srch = '') => {
  api.get('/renter', { params: { search: srch } })
  .then(response => {
    renters.value = response.data;
  })
  .catch(error => {
    console.log(error);
  });
};

const onItemClickRent = (renterItem) => {
  rentToEdit.value.renterId = renterItem.id;
};

const rentToEdit = ref({
  renterId: '',
  bookId: '',
  deadLine: '',
});

const onItemClickEdit = (renterItem, rentToEdit) => {
  rentToEdit.renterId = renterItem.id;
}

const editRent = (id, rentToEdit) => {
  api.put('/rent/update/' + id, rentToEdit)
  .then(response => {
    console.log("Sucesso", response);
    showNotification('positive', "Aluguel atualizado com sucesso!");
    dialogs.value.edit.visible = false;
    getRows();
  })
  .catch(error => {
    console.log("Erro ao editar aluguel", error);
    showNotification('negative', "Erro ao atualizar aluguel!");
  });
};

const editAction = (id, rentToEdit) => {
  console.log(id)
  editRent(id, rentToEdit);
};

const rentersFilter = (val, update, abort) => {
  if (val === '') {
    update(() => {
      getRenters();
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
</script>

<style scoped>
  .radios{
    border-radius: 20px;
  }
</style>
