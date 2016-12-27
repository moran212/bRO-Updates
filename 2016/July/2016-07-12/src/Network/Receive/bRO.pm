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
	'0895', '0936', '0863', '0925', '089B', '0926', '0897', '086E', '0883', '0877', '093F', '0886', '0941', '0937', '0923', '086C', '08AA', '08A6', '0867', '0931', '086D', '0868', '0881', '094A', '093A', '02C4', '094E', '0966', '0963', '0365', '0928', '0861', '091D', '0957', '092F', '0862', '0864', '0950', '0891', '091F', '08AB', '0890', '0940', '083C', '093E', '08A1', '092D', '0368', '085B', '0866', '0865', '085C', '0918', '087B', '0960', '0917', '0933', '094F', '0962', '087D', '0947', '092B', '091B', '095F', '093B', '093C', '0899', '08AC', '085A', '0874', '0835', '0878', '086B', '0958', '092E', '08A9', '0361', '0887', '088A', '0893', '0954', '07E4', '0921', '0281', '0884', '0942', '0202', '0363', '0892', '095E', '08A7', '08A8', '0961', '07EC', '0880', '0967', '0879', '0929', '035F', '0811', '0944', '088B', '0919', '092A', '0889', '0885', '0898', '0888', '08A3', '087C', '0934', '0949', '0437', '092C', '0951', '0952', '0838', '0438', '095C', '087E', '08A2', '0927', '022D', '0869', '091C', '0948', '023B', '0945', '089A', '0860', '086F', '095A', '0870', '0815', '089F', '095B', '0367', '0360', '0871', '086A', '08AD', '0924', '0969', '0968', '0894', '0896', '0364', '094B', '0964', '091E', '0876', '08A4', '08A5', '0436', '087A', '089D', '0819', '0873', '091A', '0366', '0802', '089E', '088C', '0930', '088D', '0932', '096A', '0875', 
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