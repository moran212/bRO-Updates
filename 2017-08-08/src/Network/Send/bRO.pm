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
package Network::Send::bRO;
use strict;
use base 'Network::Send::ServerType0';
use Log qw(debug);
use Translation qw(T TF);

sub new {
	my ($class) = @_;
	my $self = $class->SUPER::new(@_);
	
	my %packets = (
		'0932' => ['actor_action', 'a4 C', [qw(targetID type)]],
		'07E4' => ['skill_use', 'v2 a4', [qw(lv skillID targetID)]],
		'0939' => ['character_move','a3', [qw(coords)]],
		'0888' => ['sync', 'V', [qw(time)]],
		'093D' => ['actor_look_at', 'v C', [qw(head body)]],
		'088D' => ['item_take', 'a4', [qw(ID)]],
		'091C' => ['item_drop', 'a2 v', [qw(ID amount)]],
		'023B' => ['storage_item_add', 'a2 V', [qw(ID amount)]],
		'0927' => ['storage_item_remove', 'a2 V', [qw(ID amount)]],
		'0872' => ['skill_use_location', 'v4', [qw(lv skillID x y)]],
		'087F' => ['actor_info_request', 'a4', [qw(ID)]],
		'091D' => ['actor_name_request', 'a4', [qw(ID)]],
		'088C' => ['item_list_res', 'v V2 a*', [qw(len type action itemInfo)]],
		'0866' => ['map_login', 'a4 a4 a4 V C', [qw(accountID charID sessionID tick sex)]],
		'089B' => ['party_join_request_by_name', 'Z24', [qw(partyName)]], #f
		'0945' => ['homunculus_command', 'v C', [qw(commandType, commandID)]], #f
		'08AC' => ['storage_password'],
	);
	
	$self->{packet_list}{$_} = $packets{$_} for keys %packets;
	
	my %handlers = qw(
		master_login 02B0
		buy_bulk_vender 0801
		party_setting 07D7
		send_equip 0998
	);
	
	while (my ($k, $v) = each %packets) { $handlers{$v->[0]} = $k}
	$self->{packet_lut}{$_} = $handlers{$_} for keys %handlers;
	$self->cryptKeys(1030952808, 1974162452, 1105005978);

	return $self;
}

sub sendTop10 {
	my ($self, $type) = @_;
	my $type_msg;
	
	$self->sendToServer(pack("v2", 0x097C, $type));
	
	if ($type == 0x0) { $type_msg = T("Blacksmith"); }
	elsif ($type == 0x1) { $type_msg = T("Alchemist"); }
	elsif ($type == 0x2) { $type_msg = T("Taekwon"); }
	elsif ($type == 0x3) { $type_msg = T("PK"); }
	else { $type_msg = T("Unknown"); }
	
	debug TF("Sent Top 10 %s request\n", $type_msg), "sendPacket", 2;
}

sub sendTop10Blacksmith {
	sendTop10(shift, 0x0);
}

sub sendTop10Alchemist {
	sendTop10(shift, 0x1);
}

sub sendTop10Taekwon {
	sendTop10(shift, 0x2);
}

sub sendTop10PK {
	sendTop10(shift, 0x3);
}

1;