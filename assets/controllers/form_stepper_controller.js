import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
    static targets = ['step']

    connect() {
        this.currentStepIndex = 0;
        this.showStep(this.currentStepIndex);
    }

    next() {
        if (this.currentStepIndex < this.stepTargets.length - 1) {
            this.currentStepIndex++;
            this.showStep(this.currentStepIndex);
        }
    }

    previous() {
        if (this.currentStepIndex > 0) {
            this.currentStepIndex--;
            this.showStep(this.currentStepIndex);
        }
    }

    showStep(index) {
        this.stepTargets.forEach((step, i) => {
            step.style.display = i === index ? 'block' : 'none';
        });
    }
}
