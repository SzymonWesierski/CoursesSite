import { Controller } from '@hotwired/stimulus';
import $ from 'jquery';
import 'owl.carousel';

export default class extends Controller {
    connect() {
        $(this.element).owlCarousel({
            loop: true,
            margin: 10,
            nav: true,
            autoplay: true,
            responsive: {
                0: { items: 1 },
                600: { items: 2 },
                900: { items: 3 }
            },
            navText: ["<img src=\"/icons/bg-white-left-arrow.svg\" alt=\"arrow-left\">", "<img src=\"/icons/bg-white-right-arrow.svg\" alt=\"arrow-right\">"]
        });
    }

    disconnect() {
        $(this.element).trigger('destroy.owl.carousel');
    }
}
