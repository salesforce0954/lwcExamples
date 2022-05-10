import { LightningElement,api,track,wire } from 'lwc';
import captainInfo from '@salesforce/apex/App_iplCaptainInfo.captainInfo'
import captainDetails from '@salesforce/apex/App_iplCaptainInfo.captainDetails'
export default class IplTeamCaptainInfo extends LightningElement {

@track teamId;
@track teamInfoList;
@track playerId;
@track playerListInfo;
@track isChecked;
@track playerValue;
@track playerArray = [];
handleIplTeamId(event){
        this.teamId = event.detail;               
    }
    @wire(captainInfo,{teamId:'$teamId'}) 
    teamList({data,error}){
        if(data){
            this.teamInfoList = data;
        }
    }

    @wire(captainDetails,{captainId:'$playerId'})
    playerList({data,error}){
        if(data){
         this.playerListInfo = data;
         console.log('Player List'+this.playerListInfo);
        }
    }

    getPlayerInfo(event){
         console.log('Player Id ' + event.target.value);
         this.playerId = event.target.value;
         this.isChecked = event.target.checked;

        // const playerEvent = new CustomEvent(playerinformation,{detail:this.playerId});
         //this.dispatchEvent(playerEvent);

    }

    teamDetails(event){
        console.log('PlayerName '+event.target.value);
        console.log(event.target.dataset.index);
        //console.log('Player Key' + event.target.dataset.key)

        this.playerValue = event.target.value;

        let playerNames =[];
        playerNames.push(this.playerValue);
        console.log('Player Names '+playerNames[0]);
        if(playerNames.includes('Kane Stuart Williamson')){
            console.log('Exists',JSON.stringify(playerNames));
            this.playerArray = ["Nicholas Pooran","Romario Shepherd","Umran Malik","Bhuvneshwar Kumar"];
            console.log(JSON.stringify(this.playerArray));

        }else{
            console.log('No');
        }
    }
}