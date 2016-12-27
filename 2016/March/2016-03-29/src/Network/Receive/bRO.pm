#############################################################################
#  OpenKore - Network subsystem												#
#  This module contains functions for sending messages to the server.		#
#																			#
#  This software is open source, licensed under the GNU General Public		#
#  License, version 2.														#
#  Basically, this means that you're allowed to modify and distribute		#
#  this software. However, if you distribute modified versions, you MUST	#
#  also distribute the source code.											#
#  See http://www.gnu.org/licenses/gpl.html for the full license.			#
#############################################################################
# bRO (Brazil)
package Network::Receive::bRO;
use strict;
use Log qw(warning);
use base 'Network::Receive::ServerType0';

# Sync_Ex algorithm developed by Fr3DBr
sub new {
	my ($class) = @_;
	my $self = $class->SUPER::new(@_);
	
	my %packets = (
		'0097' => ['private_message', 'v Z24 V Z*', [qw(len privMsgUser flag privMsg)]], # -1
	);
	# Sync Ex Reply Array 
	$self->{sync_ex_reply} = {
	'085D', '0935', '0870', '08AA', '08A2', '0940', '08A9', '0963', '08A7', '087F', '0961', '0436', '085E', '0921', '091C', '089B', '0882', '0894', '0958', '0966', '0364', '0948', '095D', '086D', '0877', '0920', '085C', '0936', '08A8', '087D', '088C', '08A1', '095B', '0891', '0969', '02C4', '08AB', '0860', '0887', '0927', '083C', '08AC', '0956', '085B', '0281', '091E', '088D', '0369', '0929', '0862', '094B', '085F', '092C', '0925', '0835', '0869', '0962', '0437', '0946', '0923', '0932', '0366', '094F', '088A', '0953', '0933', '092D', '094D', '087A', '094C', '095A', '08AD', '092F', '0838', '0897', '08A5', '0924', '0438', '0960', '0939', '0875', '0945', '0931', '022D', '0949', '091B', '0819', '0861', '0942', '092A', '088B', '08A3', '07EC', '091F', '0360', '0879', '095E', '089D', '094A', '086B', '0952', '088E', '0917', '023B', '0930', '0947', '0950', '0888', '087C', '0876', '088F', '0365', '0865', '035F', '089E', '0866', '0898', '0968', '0965', '091D', '0362', '0367', '07E4', '087B', '0872', '0919', '0885', '089C', '0944', '0874', '08A4', '0938', '08A6', '0896', '0867', '086C', '0967', '0922', '0811', '0886', '0363', '093C', '08A0', '086F', '092E', '092B', '085A', '0943', '093A', '093F', '0863', '094E', '0202', '0802', '0918', '0934', '095F', '0815', '086A', '0884', '0928', '096A', '0926', '0937', '0889', '093D', '095C', '0864', 
	};
	
	foreach my $key (keys %{$self->{sync_ex_reply}}) { $packets{$key} = ['sync_request_ex']; }
	foreach my $switch (keys %packets) { $self->{packet_list}{$switch} = $packets{$switch}; }
	
	return $self;
}

sub items_nonstackable {
	my ($self, $args) = @_;

	my $items = $self->{nested}->{items_nonstackable};

	if($args->{switch} eq '00A4' || $args->{switch} eq '00A6' || $args->{switch} eq '0122') {
		return $items->{type4};
	} elsif ($args->{switch} eq '0295' || $args->{switch} eq '0296' || $args->{switch} eq '0297') {
		return $items->{type4};
	} elsif ($args->{switch} eq '02D0' || $args->{switch} eq '02D1' || $args->{switch} eq '02D2') {
		return  $items->{type4};
	} else {
		warning("items_nonstackable: unsupported packet ($args->{switch})!\n");
	}
}

*parse_quest_update_mission_hunt = *Network::Receive::ServerType0::parse_quest_update_mission_hunt_v2;
*reconstruct_quest_update_mission_hunt = *Network::Receive::ServerType0::reconstruct_quest_update_mission_hunt_v2;

1;
