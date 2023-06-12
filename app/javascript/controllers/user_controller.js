import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    loader(){
        document.getElementById("user_form").classList.add("d-none");
        document.getElementById("loader").classList.remove("d-none");
    }
}
