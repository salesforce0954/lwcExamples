import { LightningElement } from 'lwc';

export default class LifeCycleChild extends LightningElement {
    constructor(){
        super();
        console.log('Child constructor is called');
    }
    connectedCallback(){
        console.log('Child connected call back is called');
    }
    renderedCallback(){
        console.log('child rendered call back is called');
    }
    render(){
        console.log('Render child is called');
    }
    disconnectedCallback(){
        console.log('Disconnected child is called');
    }
}