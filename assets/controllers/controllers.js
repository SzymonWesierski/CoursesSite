import { Application } from '@hotwired/stimulus';
import ExampleController from './example_controller';

// Tworzymy instancję aplikacji
const application = Application.start();

// Rejestrujemy kontroler
application.register('example', ExampleController);
