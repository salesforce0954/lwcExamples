import { LightningElement,track } from 'lwc';

export default class CalculatorExample extends LightningElement {

@track firstNumber;
@track secondNumber;
@track calculationResult;
@track prevResult = [];
@track displayPreviousResult = false;

handleFirstNumber(event){
    if(event.target.name == 'inputOne'){
        this.firstNumber = event.target.value;
    }
}

handleSecondNumber(event){
    if(event.target.name == 'inputTwo'){
      this.secondNumber = event.target.value; 
    }
}

handleAdd(){
    this.calculationResult = parseInt(this.firstNumber) + parseInt(this.secondNumber);
    this.prevResult.push(this.calculationResult);
    console.log(this.prevResult);
}

handleSub(){
   this.calculationResult = parseInt(this.firstNumber) - parseInt(this.secondNumber);
   this.prevResult.push(this.calculationResult);
   console.log(this.prevResult);
}

previousResult(event){
    console.log(1);
    this.displayPreviousResult = event.target.checked;
    console.log(this.displayPreviousResult);
    
}

}