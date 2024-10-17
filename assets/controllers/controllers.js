import { Application } from '@hotwired/stimulus';
import OwlCarouselController from './owl_carousel_controller';
import FormStepperController from './form_stepper_controller';

const application = Application.start();

application.register('owl-carousel', OwlCarouselController);

application.register('form-stepper', FormStepperController);

// Opcjonalnie: rejestracja innych kontrolerów z folderu
const context = require.context('./', true, /\.js$/);
application.load(definitionsFromContext(context));



