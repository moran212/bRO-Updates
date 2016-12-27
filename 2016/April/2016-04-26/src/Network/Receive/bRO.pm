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
	'091F', '0955', '0917', '0959', '094A', '093E', '0933', '0932', '094D', '08A9', '086F', '0967', '0874', '0838', '0361', '094E', '0894', '085A', '0953', '087E', '0896', '0891', '0929', '0364', '095E', '0964', '0819', '087B', '091D', '088A', '0868', '086E', '0937', '087F', '093B', '08AC', '089E', '07EC', '092E', '0436', '092C', '08A8', '094C', '093C', '089A', '0934', '0898', '0878', '0925', '093F', '089F', '0866', '0940', '0923', '086C', '096A', '0945', '0863', '092D', '0961', '091E', '085D', '088C', '0963', '0864', '087D', '0865', '07E4', '0957', '089B', '0899', '0368', '08A2', '088E', '0802', '0944', '0437', '08A0', '089D', '0887', '0893', '08A3', '086A', '0882', '083C', '0960', '0889', '0817', '0202', '0943', '0956', '0438', '0948', '0920', '087A', '0954', '0919', '0958', '023B', '0969', '0930', '0362', '0892', '08AD', '094B', '0924', '0367', '0366', '0811', '022D', '085C', '086D', '0968', '088D', '0872', '0927', '0861', '0966', '08A4', '0926', '095C', '0879', '08A7', '0880', '094F', '0869', '086B', '08A6', '089C', '0876', '092F', '095D', '0885', '0881', '0897', '0835', '0888', '0360', '0871', '092B', '0862', '0965', '0935', '02C4', '0928', '0873', '0931', '0918', '0921', '0886', '091A', '0870', '0365', '0363', '0942', '0946', '0860', '095B', '0949', '092A', '08AB', '088B', '085B', '0369', '0890', '0922', '0867', '091B', 
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