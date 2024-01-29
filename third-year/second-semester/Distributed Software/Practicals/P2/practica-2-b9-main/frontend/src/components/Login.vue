<template>
  <div id="app">
    <nav class="navbar navbar-expand-lg fixed-top bg-white">
      <h1 class="navbar-text">Sport Matches</h1>
    </nav>
    <!-- Error message notification -->
    <transition name="slide-fade" mode="out-in">
      <div class="notification" v-if="errorMessage" :key="errorMessage">
        {{ errorMessage }}
      </div>
    </transition>
    <!-- Success message notification -->
    <transition name="slide-fade" mode="out-in">
      <div class="notification success" v-if="successMessage" :key="successMessage">
        {{ successMessage }}
      </div>
    </transition>
    <div class="pt-5 mt-4 matches-bg">
      <!-- Creating account -->
      <div v-if="creatingAccount" class="card login-form">
        <h2 style="margin-bottom:40px">Create Account</h2>
        <div class="form-label-group">
          <label for="inputUsername" style="float:left">Username</label>
          <input type="username" id="input-Username" class="form-control"
                 placeholder="Username" required autofocus v-model="addUserForm.username">
        </div>
        <div class="form-label-group">
          <br>
          <label for="inputPassword" style="float:left">Password</label>
          <input type="password" id="input-Password" class="form-control"
                 placeholder="Password" required v-model="addUserForm.password">
        </div>
        <br>
        <div class="flex-parent jc-center buttonMargin">
          <button :disabled="!addUserForm.username || !addUserForm.password"
                  class="btn btn-primary buttonWidth"
                  @click="signUp()">
            <b>Sign Up</b>
          </button>
        </div>
        <div class="flex-parent jc-center buttonMargin">
          <button class="btn btn-secondary buttonWidth"
                  @click="backToLogin()">Back to Sign In
          </button>
        </div>
      </div> <!-- Creating account -->
      <!-- Login -->
      <div v-else class="card login-form">
        <h2 style="margin-bottom:40px">Sign In</h2>
        <div class="form-label-group">
          <label for="inputUsername" style="float:left">Username</label>
          <input type="username" id="inputUsername" class="form-control"
                 placeholder="Username" required autofocus v-model="username">
        </div>
        <div class="form-label-group">
          <br>
          <label for="inputPassword" style="float:left">Password</label>
          <input type="password" id="inputPassword" class="form-control"
                 placeholder="Password" required v-model="password">
        </div>
        <br>
        <div class="flex-parent jc-center buttonMargin">
          <button :disabled="!username || !password"
                  class="btn btn-primary buttonWidth"
                  @click="checkLogin()">
            <b>Sign In</b>
          </button>
        </div>
        <div class="flex-parent jc-center buttonMargin">
          <button class="btn btn-success buttonWidth"
                  @click="initCreateForm()">
            <b>Create Account</b>
          </button>
        </div>
        <div class="flex-parent jc-center buttonMargin">
          <button class="btn btn-secondary buttonWidth"
                  @click="backToMatches()">Back to Matches
          </button>
        </div>
      </div><!-- Login -->
    </div>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  name: 'Login',
  data () {
    return {
      logged: false,
      path: 'http://127.0.0.1:8000/',
      username: null,
      password: null,
      token: null,
      errorMessage: null,
      successMessage: null,
      creatingAccount: false,
      addUserForm: {
        username: null,
        password: null
      }
    }
  },
  methods: {
    /* LOGIN AND ACCOUNTS */
    checkLogin () {
      const parameters = `username=${encodeURIComponent(this.username)}&password=${encodeURIComponent(this.password)}`

      const path = this.path + 'login'
      axios.post(path, parameters, {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        }
      })
        .then((res) => {
          console.log('Login Successful')
          this.logged = true
          this.token = res.data.access_token
          this.errorMessage = null
          this.successMessage = 'Login Successful'
          setTimeout(() => {
            this.successMessage = null
          }, 2000)
          this.$router.push({ path: '/', query: { username: this.username, logged: this.logged, token: this.token } })
        })
        .catch((error) => {
          console.error(error)
          this.errorMessage = error.response.data.detail
          setTimeout(() => {
            this.errorMessage = null
          }, 2000)
          throw error
        })
    },
    initCreateForm () {
      this.creatingAccount = true
      this.addUserForm.username = null
      this.addUserForm.password = null
    },
    backToLogin () {
      this.creatingAccount = false
      this.username = null
      this.password = null
    },
    backToMatches () {
      this.$router.replace({ path: '/' })
    },
    signUp () {
      const parameters = {
        username: this.addUserForm.username,
        password: this.addUserForm.password,
        is_admin: 0,
        available_money: 200
      }
      const path = this.path + 'account'
      axios.post(path, parameters)
        .then(() => {
          console.log('Register Successful')
          this.backToLogin()
          this.errorMessage = null
          this.successMessage = 'Register Successful'
          setTimeout(() => {
            this.successMessage = null
          }, 2000)
        })
        .catch((error) => {
          // eslint-disable-next-line
          console.error(error)

          if (error.response && error.response.data) {
            if (typeof error.response.data.detail === 'string') {
              this.errorMessage = error.response.data.detail
            } else if (Array.isArray(error.response.data.detail) && error.response.data.detail.length > 0) {
              this.errorMessage = error.response.data.detail[0].msg.charAt(0).toUpperCase() + error.response.data.detail[0].msg.slice(1)
            } else if (typeof error.response.data.detail === 'object' && error.response.data.detail !== null) {
              this.errorMessage = error.response.data.detail.msg
            } else {
              this.errorMessage = 'Unknown error'
            }
          } else {
            this.errorMessage = 'Unknown error'
          }
          setTimeout(() => {
            this.errorMessage = null
          }, 2000)
          throw error
        })
    }
  }
}
</script>

<style scoped>
.buttonWidth {
  width: 100%;
}

.buttonMargin {
  margin: 5px 0px 5px 0px;
}

.login-form {
  margin:0 auto;
  margin-top: 100px;
  width: 35%;
  padding: 30px 40px 30px 40px;
  background-color: white;
  float: none;
}

.navbar {
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.15);
}

.matches-bg {
  background-color: #ffdac1;
  min-height: 100vh;
}

.notification {
  position: fixed;
  top: 56px;
  left: 0;
  right: 0;
  padding: 20px;
  background-color: #f44336;
  color: white;
  text-align: center;
  z-index: 9999;
}

.slide-fade-enter-active {
  transition: all .3s ease;
}

.slide-fade-leave-active {
  transition: all .8s cubic-bezier(1.0, 0.5, 0.8, 1.0);
}

.slide-fade-enter, .slide-fade-leave-to
/* .slide-fade-leave-active below version 2.1.8 */ {
  transform: translateY(-30px);
  opacity: 0;
}

.notification.success {
  background-color: #4CAF50; /* Green background for success notifications */
}

</style>
