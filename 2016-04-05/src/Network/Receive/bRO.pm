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
	'095B', '08AD', '08A0', '0894', '0202', '0937', '0361', '0889', '0878', '095A', '094D', '0881', '0917', '0366', '089B', '0872', '0936', '08A1', '0360', '0919', '0819', '0931', '0362', '0890', '0925', '091E', '0365', '0954', '0883', '08A8', '0811', '0967', '0835', '0876', '0868', '092B', '0922', '07EC', '092C', '087E', '0918', '08A9', '089F', '095E', '0871', '0965', '0367', '0949', '0927', '086E', '088D', '0928', '0932', '0926', '087C', '08A5', '0369', '086A', '096A', '0364', '0892', '0875', '085E', '091B', '0929', '0921', '085D', '0368', '091C', '092A', '088F', '0933', '0961', '095D', '094E', '087D', '094C', '0948', '0959', '0363', '02C4', '0281', '0877', '092F', '0893', '0860', '0923', '0882', '087F', '0969', '0873', '095F', '0815', '095C', '0802', '0939', '0955', '093A', '0896', '086C', '0898', '035F', '0964', '08A2', '0953', '0960', '0891', '08A6', '0888', '089D', '0956', '0963', '0886', '0938', '093D', '0951', '091F', '091D', '0940', '0946', '085F', '0437', '0952', '088C', '093F', '023B', '0817', '0934', '08A3', '0944', '08A4', '0866', '0863', '0865', '0941', '092D', '0924', '0864', '0869', '0838', '088A', '0438', '0861', '092E', '0887', '0962', '08A7', '0862', '094F', '085A', '0968', '093C', '07E4', '094B', '086D', '022D', '08AC', '086F', '089A', '089E', '0884', '08AB', '0945', '0950', '0870', '0930', '087B', '08AA', 
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
