import { LightningElement,api,track,wire} from 'lwc';
import teamNames from '@salesforce/apex/App_iplTeamInformation.teamNames'


export default class IplTeamNames extends LightningElement {

    @track teamNameInfo;
  
    @wire(teamNames)
    teamNameList({data,error}){
        if(data){
           this.teamNameInfo = [{value:'', label:'All Types'}];
           data.forEach(element=>{
            const teamArray = {};
            teamArray.label=element.Name;
            teamArray.value=element.Id;
            this.teamNameInfo.push(teamArray);
            console.log('2 '+teamArray);
           console.log('1 '+this.teamNameInfo);
        }         
        )
        }else if(error){
            
        }   
    }
    handleIPLTeamNames(event){
            const iplTeamNameId = event.detail.value;
            console.log('Team Id '+iplTeamNameId);

            const iplCustomEvent = new CustomEvent('iplteamname',{
                detail:iplTeamNameId
            });
           

            this.dispatchEvent(iplCustomEvent);
    }
}