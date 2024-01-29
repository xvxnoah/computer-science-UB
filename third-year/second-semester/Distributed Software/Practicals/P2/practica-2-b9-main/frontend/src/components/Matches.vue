<template>
  <div id="app">
    <nav class="navbar navbar-expand-lg fixed-top bg-white">
      <h1 class="navbar-text">{{ message }}</h1>
      <div class="ml-auto" v-if="!logged">
        <button class="btn btn-outline-secondary" @click="toggleCart">{{ is_showing_cart ? 'Tanca cistella' : 'Veure cistella' }}</button>
        <button class="btn btn-outline-success" @click="goToLogin" v-if="!is_showing_cart">Log in</button>
      </div>
      <div class="ml-auto" v-else>
        <span class="navbar-text">👤 {{ username }} 💰 {{ money_available }}</span>
        <button class="btn btn-outline-secondary" @click="toggleCart">{{ is_showing_cart ? 'Tanca cistella' : `Veure cistella (${matches_added.length})` }}</button>
        <button class="btn btn-outline-danger" @click="logOut" v-if="!is_showing_cart">Log Out</button>
      </div>
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
    <div :class="{'pt-5 mt-4 matches-bg': !is_showing_cart, 'pt-5 mt-4': is_showing_cart}">
      <div v-if="is_showing_cart">
        <div class="container">
          <h1 class="my-4 text-center">Cistella</h1>
          <table v-if="matches_added.length > 0" class="table table-striped">
            <thead>
              <tr>
                <th>Sport</th>
                <th>Competition</th>
                <th>Match</th>
                <th>Quantity</th>
                <th>Price(&euro;)</th>
                <th>Total(&euro;)</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(match) in matches_added" :key="match.id">
                <td>{{ match.competition.sport }}</td>
                <td>{{ match.competition.name }}</td>
                <td>{{ match.local.name }} vs {{ match.visitor.name }}</td>
                <td>
                  {{ match.ticketCount }}
                  <button class="btn btn-decrease" @click="decreaseTicketCount(match)" :disabled="match.ticketCount === 1">-</button>
                  <button class="btn btn-increase" @click="increaseTicketCount(match)">+</button>
                </td>
                <td>{{ match.price }}</td>
                <td>{{ match.ticketCount * match.price }}</td>
                <td>
                  <button class="btn btn-delete" @click="removeEventFromCart(match)">Eliminar entrada</button>
                </td>
              </tr>
            </tbody>
          </table>
          <p v-else>Your cart is currently empty.</p>
          <div class="button-row">
            <button class="btn btn-back btn-lg animated-button" @click="toggleCart">Enrere</button>
            <button class="btn btn-finalize btn-lg animated-button" @click="finalizePurchase" :disabled="matches_added.length === 0">Finalitzar la compra</button>
          </div>
        </div>
      </div>
      <div v-else>
        <div class="container">
          <div class="row animated fadeIn">
            <div class="col-lg-4 col-md-6 mb-4" v-for="(match) in matches" :key="match.id">
              <div class="card animated flipInY">
                <img class="card-img-top" :src='require("../assets/" + match.competition.sport + ".jpg")' alt="Match image">
                <div class="card-body">
                  <h5 class="card-title">{{ match.competition.sport }} - {{ match.competition.category }}</h5>
                  <h6 class="card-subtitle mb-2 text-muted">{{ match.competition.name }}</h6>
                  <p class="card-text">
                    <strong>{{ match.local.name }}</strong> ({{ match.local.country }})
                    vs
                    <strong>{{ match.visitor.name }}</strong> ({{ match.visitor.country }})
                    <br>{{ match.date.substring(0,10) }}
                    <br>{{ match.price }} &euro;
                    <span v-if="match.total_available_tickets > 0">
                      <br>Entrades disponibles: {{ match.total_available_tickets }}
                    </span>
                  </p>
                  <button v-if="logged" class="btn btn-add-cart btn-animated" :class="{'btn-warning': isInCart(match)}" @click="toggleEventInCart(match)" :disabled="match.total_available_tickets === 0"> {{ match.total_available_tickets > 0 ? 'Afegeix a la cistella' : 'SOLD OUT' }} </button>
                  <button v-else class="btn btn-add-cart btn-animated" @click="goToLogin" :disabled="match.total_available_tickets === 0"> {{ match.total_available_tickets > 0 ? 'Inicia sessió' : 'SOLD OUT' }} </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap');
.navbar {
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.15);
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

.notification.success {
  background-color: #4CAF50; /* Green background for success notifications */
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

.fade-transform-enter-active {
  transition: opacity .3s ease, transform .3s ease;
}

.fade-transform-leave-active {
  transition: opacity .8s cubic-bezier(.55,.085,.68,.53), transform .8s cubic-bezier(.55,.085,.68,.53);
}

.fade-transform-enter, .fade-transform-leave-to
{
  transform: translateY(-20px);
  opacity: 0;
}

.matches-bg {
  background-color: #ffdac1;
  min-height: 100vh;
}

.btn-add-cart {
  background-color: #4caf50;
  color: white;
}

.btn-outline-success {
  border-color: #28a745;
  color: #28a745;
}

.btn-outline-success:hover {
  background-color: #28a745;
  color: white;
}

.btn-add-cart:hover {
  background-color: #45a049;
}

.btn-outline-secondary {
  border-color: #6c757d;
  color: #6c757d;
}

.button-row {
  display: flex;
  justify-content: center;
  gap: 20px;
}

.btn-outline-secondary:hover {
  background-color: #6c757d;
  color: white;
}

.btn-remove,
.btn-delete {
  transition: background-color 0.3s, color 0.3s;
  background-color: red;
  color: white;
}

.btn-remove:hover,
.btn-delete:hover {
  background-color: #d9534f;
}

.btn-decrease {
  background-color: red;
  color: white;
}

.btn-decrease:hover {
  background-color: #d9534f;
}

.btn-increase {
  background-color: green;
  color: white;
}

.btn-increase:hover {
  background-color: #5cb85c;
}

.btn-back {
  background-color: #6c757d;
  color: white;
}

.btn-back:hover {
  background-color: #5a6268;
}

.btn-finalize {
  background-color: green;
  color: white;
}

.btn-finalize:disabled {
  background-color: #90ee90;
  color: #004400;
}

.btn-finalize:hover {
  background-color: #5cb85c;
}

.button-row {
  display: flex;
  justify-content: center;
}

/* Animations */
@keyframes flipInY {
  0% {
    transform: perspective(400px) rotate3d(0, 1, 0, 90deg);
    animation-timing-function: ease-in;
    opacity: 0;
  }
  40% {
    transform: perspective(400px) rotate3d(0, 1, 0, -20deg);
    animation-timing-function: ease-in;
  }
  60% {
    transform: perspective(400px) rotate3d(0, 1, 0, 10deg);
    opacity: 1;
  }
  80% {
    transform: perspective(400px) rotate3d(0, 1, 0, -5deg);
  }
  100% {
    transform: perspective(400px);
  }
}

@keyframes fadeIn {
  0% {
    opacity: 0;
  }
  100% {
    opacity: 1;
  }
}

@keyframes pulse {
  0% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.05);
  }
  100% {
    transform: scale(1);
  }
}

.animated {
  animation-duration: 1s;
  animation-fill-mode: both;
}

.fadeIn {
  animation-name: fadeIn;
}

.flipInY {
  animation-name: flipInY;
}

.pulse {
  animation-name: pulse;
  animation-duration: 1.5s;
  animation-iteration-count: infinite;
}

.btn-animated:hover {
  animation-name: pulse;
  animation-duration: 1.5s;
  animation-iteration-count: infinite;
}
</style>

<script>
import axios from 'axios'

export default {
  data () {
    return {
      message: 'Sport matches',
      path: ' http://127.0.0.1:8000/',
      tickets_bought: 0,
      money_available: 0,
      matches_added: [],
      matches: [],
      successMessage: null,
      is_showing_cart: false,
      logged: false,
      errorMessage: null
    }
  },
  methods: {
    goToLogin () {
      this.$router.replace({ path: '/login' })
    },
    logOut () {
      this.logged = false
      this.$router.replace({ path: '/' })
      location.reload()
    },
    buyTicket () {
      if (this.total_tickets > 0 && this.money_available >= this.price_match) {
        this.total_tickets -= 1
        this.money_available -= this.price_match
        this.tickets_bought += 1
      }
    },
    returnTicket () {
      if (this.tickets_bought > 0) {
        this.total_tickets += 1
        this.money_available += this.price_match
        this.tickets_bought -= 1
      }
    },
    increaseTicketCount (match) {
      const foundMatch = this.matches_added.find(m => m.id === match.id)
      if (foundMatch) {
        foundMatch.ticketCount += 1
      }
      this.matches_added = [...this.matches_added]
    },
    decreaseTicketCount (match) {
      const foundMatch = this.matches_added.find(m => m.id === match.id)
      if (foundMatch && foundMatch.ticketCount > 0) {
        foundMatch.ticketCount -= 1
        match.total_available_tickets += 1
      }
      this.matches_added = [...this.matches_added]
    },
    removeMatch (match) {
      const index = this.matches.findIndex(m => m.id === match.id)
      if (index !== -1) {
        this.matches.splice(index, 1)
      }
    },
    finalizePurchase () {
      this.errorMessage = null // Clear any previous error message
      const purchases = this.matches_added.map((match) => {
        const parameters = {
          match_id: match.id,
          tickets_bought: match.ticketCount
        }
        return this.addPurchase(parameters)
      })

      Promise.all(purchases)
        .then(() => {
          this.successMessage = 'Purchase done'
          setTimeout(() => {
            this.successMessage = null
          }, 2000)
          this.matches_added = []
          this.getMatches()
          this.getAccount()
        })
        .catch((error) => {
          console.error('An error occurred while adding a purchase', error)
          if (error.response && error.response.data) {
            if (typeof error.response.data.detail === 'string') {
              this.errorMessage = error.response.data.detail
            }
          } else {
            this.errorMessage = error.message
          }
          setTimeout(() => {
            this.errorMessage = null
          }, 2000)
        })
    },
    addPurchase (parameters) {
      // eslint-disable-next-line no-template-curly-in-string
      const path = this.path + `orders/${this.username}`
      return axios.post(path, parameters, {
        headers: { 'Authorization': 'Bearer ' + this.token },
        params: { 'username': this.username }
      })
        .then(() => {
          console.log('Order done')
        })
        .catch((error) => {
          console.error('An error occurred while adding a purchase', error)
          console.log('Error detail:', error.response.data) // add this
          this.errorMessage = error.response.data.detail
          setTimeout(() => {
            this.errorMessage = null
          }, 2000)
          throw error
        })
    },
    toggleEventInCart (match) {
      if (match.total_available_tickets > 0) {
        const matchInCart = this.matches_added.find(m => m.id === match.id)
        if (matchInCart) {
          // Increase ticket count of the match already in cart
          matchInCart.ticketCount += 1
        } else {
          // Add the match to the cart and initialize ticket count to 1
          match.ticketCount = 1
          this.matches_added.push(match)
        }
        // Decrease the total available tickets
        match.total_available_tickets -= 1
      }
    },
    removeEventFromCart (match) {
      const index = this.matches_added.findIndex(m => m.id === match.id)
      if (index !== -1) {
        // Increase total available tickets by the number of tickets in the cart for this match
        match.total_available_tickets += this.matches_added[index].ticketCount
        this.matches_added[index].ticketCount = 0
        this.matches_added.splice(index, 1)
      }
    },
    isInCart (match) {
      return this.matches_added.findIndex(m => m.id === match.id) !== -1
    },
    getMatches () {
      const pathMatches = this.path + 'matches/'
      const pathCompetition = this.path + 'competitions/'

      axios.get(pathMatches)
        .then((res) => {
          var matches = res.data.filter((match) => {
            return match.competition.name != null
          })
          var promises = []
          for (let i = 0; i < matches.length; i++) {
            const promise = axios.get(pathCompetition + matches[i].competition.name)
              .then((resCompetition) => {
                matches[i].competition = {
                  'name': resCompetition.data.competition.name,
                  'category': resCompetition.data.competition.category,
                  'sport': resCompetition.data.competition.sport
                }
              })
              .catch((error) => {
                console.error(error)
              })
            promises.push(promise)
          }
          Promise.all(promises).then((_) => {
            this.matches = matches
          })
        })
        .catch((error) => {
          console.error(error)
        })
    },
    toggleCart () {
      this.is_showing_cart = !this.is_showing_cart
    },
    getAccount () {
      if (this.logged) {
        const path = this.path + `account/${this.username}`
        console.log('Username:', this.username)
        axios.get(path, {
          headers: { 'Authorization': 'Bearer ' + this.token },
          params: { 'username': this.username }
        })
          .then((res) => {
            if (res.data) {
              this.is_admin = res.data['is_admin']
              this.money_available = res.data['available_money']
            } else {
              this.logOut()
            }
          })
          .catch((error) => {
            console.error(error)
            this.logOut()
          })
      }
    }
  },
  created () {
    this.getMatches()

    this.logged = this.$route.query.logged === 'true'
    this.username = this.$route.query.username
    this.token = this.$route.query.token
    if (this.logged === undefined) {
      this.logged = false
    }

    this.getAccount()
  }
}
</script>
