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
	'093B', '07E4', '095D', '0898', '088D', '092F', '095C', '0917', '0947', '089C', '091B', '0879', '0875', '089D', '092A', '092D', '087B', '0935', '087D', '0948', '085E', '0436', '0952', '0933', '088B', '0878', '08A0', '0955', '08A3', '0872', '0930', '0869', '02C4', '08AD', '088F', '0802', '0897', '08A2', '086C', '095E', '0931', '0867', '0964', '0835', '0921', '091F', '08A7', '0954', '0969', '089A', '08A6', '0926', '0925', '0873', '023B', '0885', '0936', '0924', '0866', '0945', '091A', '0941', '0959', '0882', '0369', '0366', '095B', '0360', '087A', '0896', '0923', '0890', '089E', '0838', '0877', '08A5', '092B', '0962', '0871', '0865', '0863', '085F', '0953', '094D', '0437', '0888', '095F', '0811', '0956', '0815', '087E', '0895', '085A', '091E', '083C', '085D', '0946', '0940', '0922', '0817', '0961', '093D', '0934', '0957', '0892', '085C', '087C', '086D', '0963', '08AC', '08AB', '0880', '0951', '08A8', '0949', '0960', '0862', '091D', '0361', '0889', '094F', '0950', '094B', '093F', '08A4', '0876', '0943', '0891', '096A', '0281', '08A9', '0202', '0881', '08A1', '0860', '0893', '0928', '0864', '0927', '0368', '0883', '0819', '0937', '087F', '086B', '0929', '0932', '0886', '0968', '086F', '092C', '0944', '0868', '089F', '0438', '0918', '0899', '0363', '0966', '035F', '094C', '091C', '086E', '088E', '094E', '095A', '088C', '089B', 
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