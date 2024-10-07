import { Controller } from '@hotwired/stimulus';

// Tworzymy kontroler
export default class extends Controller {
    // Metoda wywoływana po kliknięciu przycisku
    changeText() {
        this.element.textContent = 'Tekst został zmieniony!';
    }
}