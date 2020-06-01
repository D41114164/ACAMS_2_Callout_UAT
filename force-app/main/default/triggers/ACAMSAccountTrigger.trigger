trigger ACAMSAccountTrigger on Account (before insert, before update, after update, after insert) {
    (new ACAMSAccountTriggerHandler()).run();
}