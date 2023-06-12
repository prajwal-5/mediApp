import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    leftScroll() {
        const left = document.querySelector(".scroll-days");
        left.scrollBy(-500, 0);

    }

    rightScroll() {
        const right = document.querySelector(".scroll-days");
        right.scrollBy(500, 0);
    }
}
