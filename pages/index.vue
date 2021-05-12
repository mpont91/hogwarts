<template>
  <v-app>
    <v-container fluid class="pa-0 ma-0 background">
      <v-dialog
        v-model="dialog"
        transition="dialog-bottom-transition"
        persistent
        width="800px"
      >
        <v-card class="pa-12" dark>
          <template v-if="!house && !currentQuestion">
            <v-card-title class="justify-center display-1">
              Are you ready?
            </v-card-title>
            <v-card-actions class="justify-center">
              <v-btn x-large @click="flow"> Begin</v-btn>
            </v-card-actions>
          </template>
          <template v-if="currentQuestion">
            <v-card-title class="justify-center display-1">
              {{ currentQuestion.text }}
            </v-card-title>
            <v-card-actions class="justify-center display-1">
              <v-btn
                v-for="(answer, index) in currentQuestion.answers"
                :key="index"
                class="mx-4"
                x-large
                @click="setAnswer(answer)"
              >
                {{ answer }}
              </v-btn>
            </v-card-actions>
          </template>
          <template v-if="house">
            <v-card-title class="justify-center display-1">
              {{ house }}
            </v-card-title>
            <v-card-actions class="justify-center display-2">
              <v-btn x-large @click="restart"> Start again?</v-btn>
            </v-card-actions>
          </template>
        </v-card>
      </v-dialog>
    </v-container>
  </v-app>
</template>

<script>
const ROOT = 1
const INTELLIGENCE = 'Intelligence'
const BRAVERY = 'Bravery'
const LION = 'Lion'
const SNAKE = 'Snake'
const SWORD = 'Sword'
const LOCKET = 'Locket'
const WEREWOLF = 'Werewolf'
const BASILISK = 'Basilisk'
const TRANSFIGURATION = 'Transfiguration'
const POTIONS = 'POTIONS'
const RED = 'RED'
const GREEN = 'GREEN'
const WITTY = 'Witty'
const COOK = 'A good cook'
const FIRE = 'Fire'
const WATER = 'Water'
const FRIAR = 'Fat friar'
const BARON = 'Baron'
const GRYFFINDOR = 'Gryffindor'
const RAVENCLAW = 'Ravenclaw'
const HUFFLEPUFF = 'Hufflepuff'
const SLYTHERIN = 'Slytherin'

export default {
  data() {
    return {
      dialog: false,
      currentQuestion: null,
      lastAnswer: null,
      house: null,
      questions: [
        {
          previous: [ROOT],
          text: 'Which is more important?',
          answers: [INTELLIGENCE, BRAVERY],
        },
        {
          previous: [INTELLIGENCE],
          text: 'Which animal would you rather be?',
          answers: [LION, SNAKE],
        },
        {
          previous: [LION],
          text: 'Which would you rather have?',
          answers: [SWORD, LOCKET],
        },
        {
          previous: [SWORD],
          text: "What's your favorite magical creature?",
          answers: [WEREWOLF, BASILISK],
        },
        {
          previous: [LOCKET, RED, BASILISK],
          text: 'Which would you rather be?',
          answers: [WITTY, COOK],
        },
        {
          previous: [SNAKE, TRANSFIGURATION, FIRE],
          text: 'Which color do you prefer?',
          answers: [RED, GREEN],
        },
        {
          previous: [BRAVERY],
          text: 'What would you rather learn about?',
          answers: [TRANSFIGURATION, POTIONS],
        },
        {
          previous: [POTIONS],
          text: 'Which element is better?',
          answers: [FIRE, WATER],
        },
        {
          previous: [COOK, GREEN, WATER],
          text: 'Who is the coolest ghost?',
          answers: [FRIAR, BARON],
        },
      ],
      endings: [
        {
          answer: WEREWOLF,
          house: GRYFFINDOR,
          sound: new Audio('/gryffindor.mp3'),
        },
        {
          answer: WITTY,
          house: RAVENCLAW,
          sound: new Audio('/ravenclaw.mp3'),
        },
        {
          answer: FRIAR,
          house: HUFFLEPUFF,
          sound: new Audio('/hufflepuff.mp3'),
        },
        {
          answer: BARON,
          house: SLYTHERIN,
          sound: new Audio('/slytherin.mp3'),
        },
      ],
    }
  },
  mounted() {
    setTimeout(() => {
      this.dialog = true
    }, 2000)
  },
  methods: {
    flow() {
      if (!this.lastAnswer) {
        this.setFirstQuestion()
      } else {
        const ending = this.endings.filter((e) => e.answer === this.lastAnswer)
        if (ending.length === 1) {
          this.end(ending[0])
        } else {
          this.setNextQuestion()
        }
      }
    },
    setFirstQuestion() {
      this.currentQuestion = this.questions.filter((q) => {
        return q.previous.includes(ROOT)
      })[0]
    },
    setNextQuestion() {
      this.currentQuestion = this.questions.filter((q) => {
        return q.previous.includes(this.lastAnswer)
      })[0]
    },
    setAnswer(answer) {
      this.lastAnswer = answer
      this.flow()
    },
    end(ending) {
      this.currentQuestion = null
      this.house = ending.house
      ending.sound.play()
    },
    restart() {
      this.house = null
      this.currentQuestion = null
      this.lastAnswer = null
    },
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
