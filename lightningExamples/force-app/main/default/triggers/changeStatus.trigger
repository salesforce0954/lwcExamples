trigger changeStatus on Case (before update) {

for(case c:Trigger.new)
{
  if(c.Status=='Escalated')
  {
     c.OwnerId='00G7F000000ifV4';
  }
}

}