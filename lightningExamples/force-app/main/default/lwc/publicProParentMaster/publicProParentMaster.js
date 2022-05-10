import { LightningElement } from 'lwc';

export default class PublicProParentMaster extends LightningElement {


    meetingRoomDetails = [
      {
        roomName:'Room 1',roomCapacity:'A01'
      },
      {
        roomName:'Room 2',roomCapacity:'A02'
    }, {
        roomName:'Room 3',roomCapacity:'A03'
    }, {
        roomName:'Room 4',roomCapacity:'A04'
    }


    ]
}