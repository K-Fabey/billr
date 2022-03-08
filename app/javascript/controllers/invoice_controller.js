import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['form']

  connect() {
    console.log('Hello, Stimulus!');
    console.log(this.formTarget);

  }
  decline (event) {
    event.preventDefault();
    this.formTarget.classList.toggle('d-none');
  }
}
