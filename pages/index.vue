<template>
  <v-app>
    <v-fade-transition>
      <v-app-bar v-if="barView" dark height="100">
        <v-progress-linear v-model="progressBar" height="75" color="green">
          <strong class="headline">
            {{ processed }} / {{ totalStudents }} Students
          </strong>
        </v-progress-linear>
      </v-app-bar>
    </v-fade-transition>
    <v-container fluid class="pa-0 ma-0 background">
      <v-dialog
        v-model="dialog"
        transition="dialog-bottom-transition"
        persistent
        width="800px"
      >
        <v-card class="pa-12" dark>
          <template v-if="!setUp">
            <v-card-title class="justify-center display-1">
              Set up students
            </v-card-title>
            <v-card-text>
              <v-form ref="form">
                <v-text-field
                  v-model="students.GRYFFINDOR"
                  :label="GRYFFINDOR"
                  :rules="[ruleRequired, ruleNumeric]"
                ></v-text-field>
                <v-text-field
                  v-model="students.RAVENCLAW"
                  :label="RAVENCLAW"
                  :rules="[ruleRequired, ruleNumeric]"
                ></v-text-field>
                <v-text-field
                  v-model="students.HUFFLEPUFF"
                  :label="HUFFLEPUFF"
                  :rules="[ruleRequired, ruleNumeric]"
                ></v-text-field>
                <v-text-field
                  v-model="students.SLYTHERIN"
                  :label="SLYTHERIN"
                  :rules="[ruleRequired, ruleNumeric]"
                ></v-text-field>
              </v-form>
            </v-card-text>
            <v-card-actions class="justify-center">
              <v-btn x-large @click="start">Start</v-btn>
            </v-card-actions>
          </template>
          <template v-if="readyView">
            <v-card-title class="justify-center display-1">
              Are you ready?
            </v-card-title>
            <v-card-actions class="justify-center">
              <v-btn x-large @click="flow"> Begin</v-btn>
            </v-card-actions>
          </template>
          <template v-if="questionsView">
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
          <template v-if="endingHouseView">
            <v-card-title class="justify-center display-1">
              {{ house }}
            </v-card-title>
            <v-card-actions class="justify-center display-2">
              <v-btn x-large @click="nextStudent"> Next student?</v-btn>
            </v-card-actions>
          </template>
          <template v-if="endingView">
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
  GRYFFINDOR,
  RAVENCLAW,
  HUFFLEPUFF,
  SLYTHERIN,
  data() {
    return {
      GRYFFINDOR,
      RAVENCLAW,
      HUFFLEPUFF,
      SLYTHERIN,
      dialog: false,
      currentQuestion: null,
      lastAnswer: null,
      house: null,
      setUp: false,
      students: {
        GRYFFINDOR: null,
        RAVENCLAW: null,
        HUFFLEPUFF: null,
        SLYTHERIN: null,
      },
      processed: 0,
      ruleRequired: (v) => !!v || 'This field is required',
      ruleNumeric: (v) =>
        (!!v && !isNaN(parseInt(v))) || 'This field must be numeric',
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
  computed: {
    setUpView() {
      return !this.house && !this.currentQuestion && !this.setUp
    },
    readyView() {
      return !this.house && !this.currentQuestion && this.setUp
    },
    questionsView() {
      return !!this.currentQuestion
    },
    endingHouseView() {
      return !!this.house
    },
    endingView() {
      return this.processed >= this.totalStudents
    },
    totalStudents() {
      let total = 0
      // eslint-disable-next-line no-unused-vars
      for (const [key, value] of Object.entries(this.students)) {
        total += parseInt(value)
      }
      return total
    },
    progressBar() {
      if (this.processed <= 0) {
        return 0
      } else {
        return Math.ceil((this.processed / this.totalStudents) * 100)
      }
    },
    barView() {
      return !!this.setUp
    },
  },
  mounted() {
    setTimeout(() => {
      this.dialog = true
    }, 2000)
  },
  methods: {
    start() {
      if (this.$refs.form.validate()) {
        this.setUp = true
        this.flow()
      }
    },
    flow() {
      if (!this.lastAnswer) {
        this.setFirstQuestion()
      } else {
        const ending = this.endings.filter((e) => e.answer === this.lastAnswer)
        if (ending.length === 1) {
          this.endHouse(ending[0])
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
    endHouse(ending) {
      this.currentQuestion = null
      this.house = ending.house
      this.processed++
      ending.sound.play()
    },
    nextStudent() {
      this.house = null
      this.currentQuestion = null
      this.lastAnswer = null
    },
    restart() {
      this.setUp = false
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
