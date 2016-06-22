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
	'0922', '085B', '0882', '0938', '093D', '0868', '089E', '0963', '088A', '093C', '0960', '092C', '0437', '096A', '0886', '0926', '0864', '0934', '0880', '088C', '0917', '08AD', '0877', '085F', '0961', '089F', '08AB', '094D', '0366', '0954', '08A4', '0893', '0802', '092B', '0815', '0863', '083C', '089D', '0939', '0364', '0932', '0835', '095A', '0838', '092E', '0365', '0438', '0969', '085A', '087B', '0937', '0952', '0931', '0897', '0959', '0956', '095C', '087E', '0436', '085E', '0953', '08A6', '0361', '022D', '091C', '0968', '08AC', '0875', '0369', '0872', '0933', '0899', '091D', '035F', '088D', '0879', '093F', '0892', '086F', '07EC', '0363', '0860', '0928', '0945', '095E', '0867', '0888', '0920', '0898', '0362', '0929', '088B', '0887', '0891', '0948', '0951', '093A', '086D', '0941', '08A8', '0896', '086E', '088F', '094A', '0964', '0942', '0367', '0950', '0862', '0957', '0924', '07E4', '086A', '085D', '0876', '08A3', '092F', '0947', '0884', '0281', '0967', '0943', '0936', '0202', '0962', '0940', '0817', '0360', '087F', '08A5', '0919', '023B', '0965', '092D', '089C', '08AA', '0946', '0885', '0958', '0861', '0925', '0881', '094B', '095B', '0944', '0811', '089A', '0873', '0870', '0949', '0878', '0874', '095D', '092A', '0865', '0894', '02C4', '087A', '0869', '089B', '091E', '08A9', '0935', '087C', '086C', '0889', '088E', '091B', 
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