<template>
  <q-page padding class="backStyle">
    <div class="main">
      <div class="flex justify-evenly">
        <div>
          <chartBarComponent />
        </div>
        <div>
          <chartPieComponent />
        </div>
      </div>

      <p class="text-center text-bold text-h6">Relação de locatários e empréstimos</p>

      <TableComponent
        :rows="sortedRows"
        :columns="columns"
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
    </div>
  </q-page>
</template>

<script setup>
import { useQuasar } from 'quasar';
import { ref, computed, onMounted } from 'vue';
import { api } from 'src/boot/axios';
import chartBarComponent from 'src/components/chartBarComponent.vue';
import chartPieComponent from 'src/components/chartPieComponent.vue';
import TableComponent from 'src/components/TableComponent.vue';

const $q = useQuasar();
const srch = ref('');
const rows = ref([]);
const sortBy = ref('');
const sortDesc = ref(false);

const columns = [
  { name: 'name', required: true, label: 'Locatário', align: 'center', field: row => row.name, sortable: true },
  { name: 'rentsQuantity', align: 'center', label: 'Total de empréstimos', field: 'rentsQuantity', sortable: true },
  { name: 'rentsActive', align: 'center', label: 'Aluguéis ativos', field: 'rentsActive', sortable: true },
];

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

const showNotification = (type, msg) => {
  $q.notify({
    type: type,
    message: msg,
    position: 'bottom-right',
    timeout: 3000
  });
};

onMounted(() => {
  getRows();
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
  api.get('/dashboard/rentsPerRenter', { params: {page: page.value} })
    .then(response => {
      if (Array.isArray(response.data.content)) {
        rows.value = response.data.content;
      } else {
        console.error('A resposta da API não é um array:', response.data);
        rows.value = [];
      }
    })
    .catch(error => {
      console.error("Erro ao obter dados:", error);
    });
};
</script>

<style scoped>
.flex {
  display: flex;
  width: 100%;
  flex-direction: row;
  margin-bottom: 1rem;
}

@media (max-width: 900px) {
  .flex {
    margin-inline: auto;
    flex-direction: column;
    gap: 5rem;
  }
}
</style>
