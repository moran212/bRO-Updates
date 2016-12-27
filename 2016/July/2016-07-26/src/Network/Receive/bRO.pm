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
	'085A', '0867', '0886', '0802', '08AC', '0878', '0873', '0919', '0866', '088A', '089F', '0817', '0958', '0951', '091F', '086A', '0361', '0366', '091C', '0882', '0860', '0367', '089E', '0930', '0945', '087F', '092F', '086E', '0920', '08AD', '087C', '035F', '0871', '0894', '0941', '0872', '0963', '088E', '0960', '0931', '0815', '088F', '092D', '08A6', '0363', '0885', '0947', '0949', '093C', '0364', '091D', '092A', '094E', '093E', '0937', '0924', '089B', '0943', '0899', '088B', '085F', '0819', '086D', '0838', '0935', '08AA', '0876', '096A', '0946', '087D', '0967', '0953', '0863', '094D', '0875', '083C', '0921', '0368', '0369', '0438', '0929', '093F', '086C', '0874', '0957', '0898', '0881', '0918', '0938', '0365', '0964', '091E', '092C', '08A3', '02C4', '089A', '022D', '08A9', '0835', '0944', '0811', '0942', '095A', '0968', '0891', '0940', '08A1', '0869', '0884', '0955', '0959', '093A', '089D', '091A', '07EC', '0928', '0877', '092B', '085B', '0932', '094B', '0952', '0954', '0933', '0436', '094F', '0966', '0897', '094C', '095D', '089C', '0925', '08A2', '0437', '0889', '094A', '0868', '095F', '093D', '0890', '0950', '08AB', '0969', '0948', '0879', '095B', '08A5', '07E4', '095E', '0923', '091B', '087A', '0917', '0939', '08A4', '0202', '0922', '085C', '086F', '0895', '0892', '0880', '0888', '0883', '088C', '088D', '0965', '0936', 
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