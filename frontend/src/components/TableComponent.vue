<template>
  <q-table
    flat
    bordered
    table-header-style="background-color: #105352; color: #fff"
    separator="cell"
    :title="title"
    :rows="rows"
    :columns="columns"
    row-key="name"
    color="primary"
    rows-per-page-label="Registros por página"
    class="radios"
  >
    <template v-slot:body-cell-actions="props">
      <q-td :props="props">
        <div v-if="!['DELIVERED_WITH_DELAY', 'IN_TIME'].includes(props.row.status)">
          <div v-if="!['admin@gmail.com'].includes(props.row.email)">
            <q-btn
              v-for="icon in icons"
              :key="icon"
              flat
              round
              :icon="icon"
              @click="handleAction(props.row, icon)"
            />
          </div>
        </div>
      </q-td>
    </template>
  </q-table>
</template>

<script setup>
import { defineProps, defineEmits } from 'vue';

defineOptions({
  name: 'TableComponent'
});

const props = defineProps({
  title: String,
  rows: Array,
  columns: Array,
  icons: Array
});

const emit = defineEmits(['action']);

const handleAction = (row, icon) => {
  emit('action', { row, icon });
};
</script>
