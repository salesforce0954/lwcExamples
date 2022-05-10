trigger creatContact on Contact (before insert) {
    for(Contact c :Trigger.New){
      c.lastName = 'recursivetestone';
      system.debug('Contact triggered');
    }
}