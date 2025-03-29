import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["question", "answer"];

  connect() {
    this.currentIndex = 0;
    this.selectedAnswers = [];
    this.questionTargets.forEach((question, index) => question.classList.toggle("d-none", index !== 0));
    this.answerTargets.forEach((answer) => answer.classList.add("d-none"));

  }

  showCurrentQuestion() {
    this.questionTargets.forEach((question, index) => {
      if (index === this.currentIndex) {
        question.classList.remove("d-none");
      } else {
        question.classList.add("d-none");
      }
    });
  }

  next() {
    if (this.currentIndex < this.questionTargets.length - 1) {
      this.questionTargets[this.currentIndex].classList.add("d-none");
      this.currentIndex++;
      this.questionTargets[this.currentIndex].classList.remove("d-none");
    }
  }

  previous() {
    if (this.currentIndex > 0) {
      this.questionTargets[this.currentIndex].classList.add("d-none");
      this.currentIndex--;
      this.questionTargets[this.currentIndex].classList.remove("d-none");
    }
  }

  finalize() {
    this.questionTargets[this.currentIndex].classList.add("d-none");
    this.answerTargets.forEach((answer, index) => {
      const selectedAnswerIndex = this.selectedAnswers[index];
      const cards = answer.querySelectorAll('.quiz-answers-card');
      const selectedCard = cards[selectedAnswerIndex];
      selectedCard.querySelector('.label').classList.remove("d-none");
      answer.classList.remove("d-none");
    });
  }

  selectAnswer(event) {
    const currentQuestion = this.questionTargets[this.currentIndex];
    const answerCards = currentQuestion.querySelectorAll('.quiz-answers-card');
    answerCards.forEach(card => card.classList.remove("selected"));
    event.currentTarget.classList.add("selected");
    const index = Array.from(answerCards).indexOf(event.currentTarget);
    this.selectedAnswers[this.currentIndex] = index;
  }
}
