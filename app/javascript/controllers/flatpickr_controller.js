import { Controller } from "stimulus";
import flatpickr from "flatpickr";

export default class extends Controller {

  connect() {
    console.log('Hello, Stimulus via flatpick!');
    flatpickr(".datepicker", {
      dateFormat: "d-m-Y"
    });
  }
}
