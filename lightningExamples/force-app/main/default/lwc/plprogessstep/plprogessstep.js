import { LightningElement,track} from 'lwc';

export default class Plprogessstep extends LightningElement {
  @track steps = [
    { label: 'Loan Details', value: 'step-1' },
    { label: 'About', value: 'step-2' },
    { label: 'Employment', value: 'step-3' },
    { label: 'Expenses', value: 'step-4' },
    { label: 'Assets', value: 'step-5' },
    { label: 'Debts', value: 'step-6' },
    { label: 'Review', value: 'step-7' },
];
}