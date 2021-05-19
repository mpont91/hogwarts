<template>
  <v-app>
    <v-fade-transition>
      <v-app-bar
        v-if="
          [VIEW_STUDENT, VIEW_QUESTIONS, VIEW_RESULT, VIEW_SUMMARY].includes(
            view
          )
        "
        dark
        height="100"
      >
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
        transition="fade-transition"
        persistent
        width="800px"
      >
        <v-card class="px-12 pb-12" dark :loading="loading">
          <v-toolbar class="py-4" color="transparent" flat>
            <p v-if="[VIEW_QUESTIONS, VIEW_RESULT].includes(view)">
              Student: {{ studentName }}
            </p>
          </v-toolbar>
          <template v-if="view === VIEW_SETUP">
            <v-card-title class="justify-center display-1">
              Set up students
            </v-card-title>
            <v-card-text>
              <v-form ref="form">
                <v-text-field
                  v-model="housesLimit.gryffindor"
                  :label="GRYFFINDOR"
                  :rules="[ruleRequired, ruleNumeric]"
                ></v-text-field>
                <v-text-field
                  v-model="housesLimit.ravenclaw"
                  :label="RAVENCLAW"
                  :rules="[ruleRequired, ruleNumeric]"
                ></v-text-field>
                <v-text-field
                  v-model="housesLimit.hufflepuff"
                  :label="HUFFLEPUFF"
                  :rules="[ruleRequired, ruleNumeric]"
                ></v-text-field>
                <v-text-field
                  v-model="housesLimit.slytherin"
                  :label="SLYTHERIN"
                  :rules="[ruleRequired, ruleNumeric]"
                ></v-text-field>
              </v-form>
            </v-card-text>
            <v-card-actions class="justify-center">
              <v-btn x-large @click="start">Start</v-btn>
            </v-card-actions>
          </template>
          <template v-if="view === VIEW_STUDENT">
            <v-card-title class="justify-center display-1">
              Are you ready?
            </v-card-title>
            <v-card-text>
              <v-text-field
                v-model="studentName"
                label="Name"
                :rules="[ruleRequired]"
              ></v-text-field>
            </v-card-text>
            <v-card-actions class="justify-center">
              <v-btn x-large @click="flow"> Start</v-btn>
            </v-card-actions>
          </template>
          <template v-if="view === VIEW_QUESTIONS">
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
          <template v-if="view === VIEW_RESULT">
            <v-card-title class="justify-center display-1">
              {{ result.house }}
            </v-card-title>
            <v-card-actions class="justify-center display-2">
              <v-btn
                v-if="processed < totalStudents"
                x-large
                @click="nextStudent"
              >
                Next student
              </v-btn>
              <v-btn v-else x-large @click="showSummary">Show results</v-btn>
            </v-card-actions>
          </template>
          <template v-if="view === VIEW_SUMMARY">
            <v-card-title class="justify-center display-1">
              Results
            </v-card-title>
            <v-card-text>
              <v-simple-table>
                <template #default>
                  <tbody>
                    <tr>
                      <th class="text-left">{{ GRYFFINDOR }}</th>
                      <td class="text-left">
                        {{ summary.gryffindor.join(', ') }}
                      </td>
                    </tr>
                    <tr>
                      <th class="text-left">{{ RAVENCLAW }}</th>
                      <td class="text-left">
                        {{ summary.ravenclaw.join(', ') }}
                      </td>
                    </tr>
                    <tr>
                      <th class="text-left">{{ HUFFLEPUFF }}</th>
                      <td class="text-left">
                        {{ summary.hufflepuff.join(', ') }}
                      </td>
                    </tr>
                    <tr>
                      <th class="text-left">{{ SLYTHERIN }}</th>
                      <td class="text-left">
                        {{ summary.slytherin.join(', ') }}
                      </td>
                    </tr>
                  </tbody>
                </template>
              </v-simple-table>
            </v-card-text>
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
const VIEW_SETUP = 'setup'
const VIEW_STUDENT = 'student'
const VIEW_QUESTIONS = 'questions'
const VIEW_RESULT = 'result'
const VIEW_SUMMARY = 'summary'
const TIMEOUT = 1000

export default {
  GRYFFINDOR,
  RAVENCLAW,
  HUFFLEPUFF,
  SLYTHERIN,
  VIEW_SETUP,
  VIEW_STUDENT,
  VIEW_QUESTIONS,
  VIEW_RESULT,
  VIEW_SUMMARY,
  data() {
    return {
      GRYFFINDOR,
      RAVENCLAW,
      HUFFLEPUFF,
      SLYTHERIN,
      VIEW_SETUP,
      VIEW_STUDENT,
      VIEW_QUESTIONS,
      VIEW_RESULT,
      VIEW_SUMMARY,
      loading: false,
      dialog: false,
      setUp: false,
      currentQuestion: null,
      lastAnswer: null,
      result: null,
      view: null,
      studentName: null,
      housesLimit: {
        gryffindor: null,
        ravenclaw: null,
        hufflepuff: null,
        slytherin: null,
      },
      summary: {
        gryffindor: [],
        ravenclaw: [],
        hufflepuff: [],
        slytherin: [],
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
      results: [
        {
          answer: WEREWOLF,
          house: GRYFFINDOR,
          sound: new Audio('/gryffindor.mp3'),
          alternatives: [RAVENCLAW, HUFFLEPUFF, SLYTHERIN],
        },
        {
          answer: WITTY,
          house: RAVENCLAW,
          sound: new Audio('/ravenclaw.mp3'),
          alternatives: [HUFFLEPUFF, SLYTHERIN, GRYFFINDOR],
        },
        {
          answer: FRIAR,
          house: HUFFLEPUFF,
          sound: new Audio('/hufflepuff.mp3'),
          alternatives: [SLYTHERIN, GRYFFINDOR, HUFFLEPUFF],
        },
        {
          answer: BARON,
          house: SLYTHERIN,
          sound: new Audio('/slytherin.mp3'),
          alternatives: [HUFFLEPUFF, RAVENCLAW, GRYFFINDOR],
        },
      ],
    }
  },
  computed: {
    totalStudents() {
      let total = 0
      // eslint-disable-next-line no-unused-vars
      for (const [key, value] of Object.entries(this.housesLimit)) {
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
  },
  mounted() {
    setTimeout(() => {
      this.dialog = true
      this.view = VIEW_SETUP
    }, TIMEOUT)
  },
  methods: {
    start() {
      if (this.$refs.form.validate()) {
        this.loading = true
        setTimeout(() => {
          this.loading = false
          this.setUp = true
          this.nextStudent()
        }, TIMEOUT)
      }
    },
    flow() {
      if (!this.lastAnswer) {
        this.setFirstQuestion()
      } else {
        const result = this.results.filter((e) => e.answer === this.lastAnswer)
        if (result.length === 1) {
          this.showResult(result[0])
        } else {
          this.setNextQuestion()
        }
      }
    },
    setFirstQuestion() {
      this.loading = true
      setTimeout(() => {
        this.loading = false
        this.currentQuestion = this.questions.filter((q) => {
          return q.previous.includes(ROOT)
        })[0]
        this.view = VIEW_QUESTIONS
      }, TIMEOUT)
    },
    setNextQuestion() {
      this.loading = true
      setTimeout(() => {
        this.loading = false
        this.currentQuestion = this.questions.filter((q) => {
          return q.previous.includes(this.lastAnswer)
        })[0]
      }, TIMEOUT)
    },
    setAnswer(answer) {
      this.lastAnswer = answer
      this.flow()
    },
    showResult(result) {
      let candidate = result
      if (
        this.summary[candidate.house.toLowerCase()].length >=
        this.housesLimit[candidate.house.toLowerCase()]
      ) {
        candidate = this.alternativeResult(result)
      }
      this.loading = true
      setTimeout(() => {
        this.loading = false
        this.currentQuestion = null
        this.result = candidate
        this.addStudent(this.result.house)
        candidate.sound.play()
        this.view = VIEW_RESULT
      }, TIMEOUT)
    },
    alternativeResult(result) {
      let found = false
      let candidate = null
      let index = 0
      while (!found && !candidate) {
        candidate = result.alternatives[index]
        found =
          this.housesLimit[candidate.toLowerCase()] <
          this.summary[candidate.toLowerCase()].length
        index++
      }
      return this.results.filter((i) => i.house === candidate)[0]
    },
    addStudent(house) {
      this.summary[house.toLowerCase()].push(this.studentName)
      this.processed++
    },
    nextStudent() {
      this.loading = true
      setTimeout(() => {
        this.loading = false
        this.result = null
        this.currentQuestion = null
        this.lastAnswer = null
        this.studentName = null
        this.view = VIEW_STUDENT
      }, TIMEOUT)
    },
    showSummary() {
      this.loading = true
      setTimeout(() => {
        this.loading = false
        this.view = VIEW_SUMMARY
      }, TIMEOUT)
    },
    restart() {
      this.loading = true
      setTimeout(() => {
        this.loading = false
        this.setUp = false
        this.result = null
        this.currentQuestion = null
        this.lastAnswer = null
        this.restartResults()
        this.restartSummary()
        this.view = VIEW_SETUP
      }, TIMEOUT)
    },
    restartResults() {
      this.housesLimit = {
        gryffindor: null,
        ravenclaw: null,
        hufflepuff: null,
        slytherin: null,
      }
    },
    restartSummary() {
      this.summary = {
        gryffindor: [],
        ravenclaw: [],
        hufflepuff: [],
        slytherin: [],
      }
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
