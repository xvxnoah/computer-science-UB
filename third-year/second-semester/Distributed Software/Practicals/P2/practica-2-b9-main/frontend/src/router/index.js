import Vue from 'vue'
import Router from 'vue-router'
import Matches from '@/components/Matches'
import Login from '@/components/Login.vue'

Vue.use(Router)

export default new Router({
  mode: 'history', // This is to remove the # from the URL
  base: process.env.BASE_URL,
  routes: [
    {
      path: '/',
      name: 'Matches',
      component: Matches
    },
    {
      path: '/login',
      name: 'Login',
      component: Login
    }
  ]
})
