<template>
  <q-layout v-if="!token" class="bgLayoutLogin flex">
    <div
      v-if="loginForm"
      class="q-pa-lg q-mx-auto card"
      style="max-width: 400px"
    >
      <div class="form">
        <q-img
          src="../assets/altislab_logo.png"
          style="height: 150px"
          fit="scale-down"
          class="q-my-auto"
        />

        <q-form
          @submit="onSubmit"
          @reset="onReset"
          class="q-gutter-md q-my-auto spacer"
        >
          <q-input
            itemid="emailInput"
            filled
            v-model="name"
            label="Digite seu email"
            hint="Digite o seu email de usuário"
            lazy-rules
            :rules="[val => !!val
            || 'Email é obrigatório', val => /^.+@gmail.com$/.test(val) ||
             'Email inválido']"
          />

          <q-input
            itemid="passwordInput"
            filled
            type="password"
            v-model="password"
            label="Senha *"
            hint="Digite a sua senha"
            lazy-rules
            :rules="[
              (val) =>
                (val !== null && val !== '') || 'Por favor, digite sua senha',
              (val) =>
                (val && val.length > 3) ||
                'A senha não pode ter menos que quatro caracteres',
            ]"
          />

          <div>
            <q-btn itemid="loginBtn" label="Login" type="submit" color="primary" />
            <q-btn @Click="forguetPassword" label="Esqueci senha" class="q-ml-sm text-center text-cyan-8 text-italic text-body2"/>
          </div>
        </q-form>
      </div>
    </div>

    <div v-else class="q-pa-lg q-mx-auto card" style="max-width: 400px">
      <div v-if="!tokenForm" class="form">
        <q-img
          src="../assets/altislab_logo.png"
          style="height: 150px"
          fit="scale-down"
          class="q-my-auto"
        />

        <div class="text-center text-bold q-mt-md text-blue-grey-8">
          Recuperação de senha
        </div>

        <q-form
          type="submit"
          @submit="sendEmailAction(userEmail)"
          @reset="onReset"
          class="q-gutter-md q-my-auto spacer"
        >
          <q-input
            filled
            v-model="userEmail.email"
            label="Digite seu email *"
            lazy-rules
            :rules="[val => !!val || 'Email é obrigatório', val => /^.+@gmail.com$/.test(val) || 'Email inválido']"
          />
          <div>
            <q-btn label="Enviar" type="submit" color="primary" />
            <q-btn
              @Click="forguetPassword"
              label="Cancelar"
              class="q-ml-sm text-center text-cyan-8 text-italic text-body2"
            />
          </div>
        </q-form>
      </div>

        <div v-if="tokenForm" class="form">
          <q-img
            src="../assets/altislab_logo.png"
            style="height: 150px"
            fit="scale-down"
            class="q-my-auto"
          />

          <q-form
            type="submit"
            @submit="sendNewPasswordAction(userNewPassword)"
            @reset="onReset"
            class="q-gutter-md q-my-auto spacer"
          >
            <q-input
              filled
              v-model="userNewPassword.token"
              label="Digite o token *"
              hint="Digite aqui o token"
              lazy-rules
            />

            <q-input
            filled
            type="password"
            v-model="userNewPassword.newPassword"
            label="Nova senha *"
            hint="Digite a sua nova senha"
            lazy-rules
            :rules="[
              (val) =>
                (val !== null && val !== '') || 'Por favor, digite sua senha',
              (val) =>
                (val && val.length > 3) ||
                'A senha não pode ter menos que quatro caracteres',
            ]"
          />

          <div>
            <q-btn label="Alterar" type="submit" color="primary" />
            <q-btn @Click="forguetPassword" label="Cancelar" class="q-ml-sm text-center text-cyan-8 text-italic text-body2"/>
          </div>
          </q-form>
        </div>
    </div>
  </q-layout>

  <q-layout view="lHh Lpr lFf" v-else>
    <q-header elevated class="bgPadrao">
      <q-toolbar>
        <q-btn
          flat
          dense
          round
          icon="menu"
          aria-label="Menu"
          @click="miniState = !miniState"
        />
        <q-toolbar-title>Locadora</q-toolbar-title>
      </q-toolbar>
    </q-header>

    <q-drawer
      dark
      v-model="drawer"
      show-if-above
      :mini="miniState"
      :width="250"
      :breakpoint="500"
      bordered
      :class="$q.dark.isActive ? 'bg-teal-9' : 'bgPadrao'"
    >
      <div class="flex-column full-height">
        <q-list>
          <q-item class="roleCss q-mt-sm q-mb-xl">
              <q-icon class="q-ml-xsm text-h5 text-blue-grey-2" :name="iconRole"/>

              <q-item-label>{{ role }}</q-item-label>
          </q-item>

          <SidebarComponent
            v-for="link in linksList"
            :key="link.title"
            v-bind="link"
          />
        </q-list>
        <div class="flex-grow"></div>
        <q-item
          itemid="logoutBtn"
          clickable
          exact
          class="q-mx-auto q-mb-sm logout"
          @click="logout"
        >
          <q-item-section avatar>
            <q-icon name="logout" />
          </q-item-section>
          <q-item-section>
            <q-item-label>Logout</q-item-label>
          </q-item-section>
        </q-item>
      </div>
    </q-drawer>

    <q-page-container>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script setup>
import { useQuasar } from "quasar";
import { ref } from "vue";
import { authenticate } from "boot/axios";
import SidebarComponent from "src/components/SidebarComponent.vue";
import { api } from "src/boot/axios";

defineOptions({
  name: "MainLayout",
});

const $q = useQuasar();

const showNotification = (type, msg) => {
  $q.notify({
    type: type,
    message: msg,
    position: "bottom-right",
    timeout: 3000,
  });
};

const token = localStorage.getItem("authToken");
const role = ref(localStorage.getItem('role'));

const iconRole = ref('thumb_up')

if (role.value == "USER") {
  iconRole.value = "face"
} else {
  iconRole.value = "supervisor_account"
}

const name = ref(null);
const password = ref(null);

const loginForm = ref(true);

const tokenForm = ref(false);

const userEmail = ref({
  email: "",
});

const userNewPassword = ref({
  token: "",
  newPassword: ""
})

const onSubmit = () => {
  if (name.value && password.value) {
    authenticate(name.value, password.value)
      .then(() => {
        name.value = null;
        password.value = null;
        window.location.reload();
      })
      .catch(() => {
        showNotification("negative", "Algo deu errado!");
      });
  } else {
    showNotification("negative", "Por favor, preencha todos os campos corretamente");
  }
};

const onReset = () => {
  name.value = null;
  password.value = null;
};

const logout = () => {
  localStorage.removeItem("authToken");
  window.location.reload();
};

const forguetPassword = () => {
  loginForm.value = !loginForm.value;
};

const sendEmail = (emailToSend) => {
  api.post("/api/forgot", emailToSend)
    .then((response) => {
      console.log("Sucesso");
      tokenForm.value = true
    })
    .catch((erro) => {
      console.log(erro.response.data);
      showNotification("negative", erro.response.data);
    });
};

const sendEmailAction = (userEmail) => {
  sendEmail(userEmail);
};

const sendNewPassword = (userNewPassword) => {
  api.post("/api/reset-password", userNewPassword)
  .then((response) => {
    console.log("Sucessou")
    loginForm.value = true
  })
  .catch((erro) => {
    console.log("ERRO");
  })
}

const sendNewPasswordAction = (userNewPassword) => {
  sendNewPassword(userNewPassword);
}

const linksList = [
  {
    title: "Relatório geral",
    icon: "moving",
    route: { name: "home" },
  },
  {
    title: "Controle de usuários",
    icon: "person",
    route: { name: "users" },
  },
  {
    title: "Controle de locatários",
    icon: "local_library",
    route: { name: "renters" },
  },
  {
    title: "Controle de editoras",
    icon: "create",
    route: { name: "publishers" },
  },
  {
    title: "Controle de livros",
    icon: "book",
    route: { name: "books" },
  },
  {
    title: "Controle de aluguéis",
    icon: "collections_bookmark",
    route: { name: "rents" },
  },
];

const drawer = ref(false);
const miniState = ref(true);
</script>

<style>
.bgLayoutLogin {
  background: linear-gradient(to right, #b3b3b3 8%, #f1fdf7 100%);
}

.form {
  width: 100%;
}

.card {
  width: 40%;
  margin-top: auto;
  margin-bottom: auto;
  padding: 2rem;
  border-radius: 5px;
  background-color: rgb(240, 240, 240);
  box-shadow: 2px 2px 5px 1px rgba(97, 97, 97, 0.58);
}

.flex {
  display: flex;
}

.whiteFont {
  color: aliceblue;
}

.bgPadrao {
  background-color: #2c3d47;
}

.roleCss{
  display: flex;
  align-items: center;
  margin-inline: auto;
  max-width: fit-content;
  gap: 5px;
  background-color: #1e6b51;
  border-radius: 8px;
}

.borderBottom {
  display: flex;
  justify-content: center;
  border-bottom: solid 1px #6e92a7;
  width: 80%;
  margin: auto
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

@media (max-width: 600px) {
  .card {
    box-shadow: none;
    width: 90%;
  }

  .bgLayoutLogin {
    background: rgb(240, 240, 240);
  }
}
</style>
