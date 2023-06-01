abstract class ProfileState {}
class ProfileInitial extends ProfileState{}

class ProfileChangeTabState extends ProfileState{}
class PassVisibilityChangeState extends ProfileState{}

class LoadingProfileState extends ProfileState{}
class LoadedProfileState extends ProfileState{}
class ErrorProfileState extends ProfileState{}

class AddLoadingProfileState extends ProfileState{}
class AddLoadedProfileState extends ProfileState{}
class AddErrorProfileState extends ProfileState{}

class ChangePassErrorState extends ProfileState{}
class ChangePassLoadingState extends ProfileState{}
class ChangePassLoadedState extends ProfileState{}

