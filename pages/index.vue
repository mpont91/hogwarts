<template>
  <v-app>
    <v-container fluid class="pa-0 ma-0 background">
      <v-row>
        <v-col class="text-center">
          <v-fade-transition>
            <v-card v-show="begin" width="75vw" class="mx-auto mt-12">
              <v-card-title class="display-2">
                Which Hogwarts House Do You Belong In?
              </v-card-title>
            </v-card>
          </v-fade-transition>
        </v-col>
      </v-row>
    </v-container>
  </v-app>
</template>

<script>
export default {
  data() {
    return {
      begin: false,
    }
  },
  mounted() {
    setTimeout(() => {
      this.begin = true
    }, 2000)
  },
}
</script>

<style scoped>
.background {
  background-image: url('~/assets/houses.jpg');
  background-repeat: no-repeat;
  background-size: cover;
  background-attachment: fixed;
  background-position: center top;
  height: 100vh;
  width: 100vw;
}
</style>
