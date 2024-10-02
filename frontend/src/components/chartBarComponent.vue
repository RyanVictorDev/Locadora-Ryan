<template>
  <div>
    <div class="chart-container">
      <div class="title">

        <span class="text-h6">Relações de livros</span>

        <span class="flex">
          Meses:

          <q-input
            v-model="numberOfMonths"
            type="number"
            filled
            class="inputMonths"
            dense
            item-aligned
            min=1
          />
        </span>


      </div>
      <canvas id="relacoesLivrosChart"></canvas>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue';
import { Chart, registerables } from 'chart.js';
import { api } from 'src/boot/axios';

Chart.register(...registerables);

defineOptions({
  name: 'chartBarComponent'
});

const numberOfMonths = ref(1);

const rentsQtd = ref(0);
const late = ref(0);
const delivered = ref(0);
const delayed = ref(0);

let chartInstance = null;

const getRents = async () => {
  try {
    const response = await api.get('/dashboard/rentsQuantity', { params: { numberOfMonths: numberOfMonths.value } });
    rentsQtd.value = response.data;
  } catch (error) {
    showNotification('negative', "Erro ao obter dados!");
    console.error("Erro ao obter dados:", error);
  }
};

const getRentsLate = async () => {
  try {
    const response = await api.get('/dashboard/rentsLateQuantity', { params: { numberOfMonths: numberOfMonths.value } });
    late.value = response.data;
  } catch (error) {
    showNotification('negative', "Erro ao obter dados!");
    console.error("Erro ao obter dados:", error);
  }
};

const getRentsDelivered = async () => {
  try {
    const response = await api.get('/dashboard/deliveredInTimeQuantity', { params: { numberOfMonths: numberOfMonths.value } });
    delivered.value = response.data;
  } catch (error) {
    showNotification('negative', "Erro ao obter dados!");
    console.error("Erro ao obter dados:", error);
  }
};

const getRentsDelayed = async () => {
  try {
    const response = await api.get('/dashboard/deliveredWithDelayQuantity', { params: { numberOfMonths: numberOfMonths.value } });
    delayed.value = response.data;
  } catch (error) {
    showNotification('negative', "Erro ao obter dados!");
    console.error("Erro ao obter dados:", error);
  }
};

const updateChart = () => {
  if (chartInstance) {
    chartInstance.data.datasets[0].data = [rentsQtd.value, late.value, delivered.value, delayed.value];
    chartInstance.update();
  }
};

const fetchDataAndUpdateChart = async () => {
  await getRents();
  await getRentsLate();
  await getRentsDelivered();
  await getRentsDelayed();
  updateChart();
};

watch(numberOfMonths, async () => {
  await fetchDataAndUpdateChart();
});

onMounted(async () => {
  await fetchDataAndUpdateChart();

  const ctx = document.getElementById('relacoesLivrosChart').getContext('2d');
  chartInstance = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: ['Alugados', 'Atrasados', 'Devolvidos no prazo', 'Devolvidos fora do prazo'],
      datasets: [{
        label: 'Relação de livros',
        data: [rentsQtd.value, late.value, delivered.value, delayed.value],
        backgroundColor: ['#509358', '#B22222', '#46769A', '#C65F15'],
        borderWidth: 0,
        borderRadius: 5
      }]
    },
    options: {
      plugins: {
        legend: {
          display: false,
          position: 'top',
        }
      }
    }
  });
});
</script>

<style scoped>
.inputMonths{
  display: flex;
  justify-content: center;
  width: 90px;
  border-radius: 15px;
}

.flex{
  display: flex;
  align-items: center;
}

#relacoesLivrosChart{
  margin-bottom: 1rem;
}

.chart-container {
  border-radius: 5px;
  padding: 15px;
  box-shadow: 1px 2px 6px 2px rgba(87, 87, 87, 0.51);
  background-color: rgb(255, 255, 255);
  width: 100%;
  min-width: 450px;
  max-width: fit-content;
  height: 290px;
  text-align: center;
}

.title {
  display: flex;
  align-items: center;
  justify-content: space-around;
  font-weight: bold;
}

canvas {
  width: 100%;
  height: 50%;
}

@media (max-width: 900px) {
  .chart-container {
    min-width: 80%;
  }
}
</style>
