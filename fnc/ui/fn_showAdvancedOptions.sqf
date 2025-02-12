#include "..\..\dialogs\advancedConfigDialog.inc"

disableSerialization;

private _display = "RSTF_RscDialogAdvancedConfig" call RSTF_fnc_getDisplay;
private _optionsContainer = ["RSTF_RscDialogAdvancedConfig", "optionsContainer"] call RSTF_fnc_getCtrl;

private _category = param [0];
private _firstLoad = param [1, false];

private _options = missionConfigFile >> "RSTF_Options" >> _category;

// Save previously displayed options
if (not _firstLoad) then {
	call RSTF_fnc_saveAdvancedOptions;
	call RSTF_fnc_profileSave;
};

call RSTF_fnc_updateEquipment;
call RSTF_fnc_updateAdvancedConfig;

// Remove previous options
{
	ctrlDelete (_x select 0);
	ctrlDelete (_x select 1);
	(_x select 0) ctrlCommit 0;
	(_x select 1) ctrlCommit 0;
} foreach RSTF_ADVANCED_LASTOPTIONS;

RSTF_ADVANCED_LASTOPTIONS = [];

private _items = "true" configClasses (_options >> "Items");
private _padding = 0.05;
private _width = RSTF_ADV_OPS_W - _padding * 2;
private _idc = 2000;
private _yy = _padding;
private _xx = _padding;
{
	private _configItem = _x;
	private _type = getText(_x >> "type");

	if (_type != 'spacer') then {
		// Load variable name and value
		private _name = configName(_x);
		private _title = getText(_x >> "title");
		private _description = getText(_x >> "description");
		private _validator = -1;
		private _value = missionNamespace getVariable [_name, ""];
		
		if (isText(_x >> "validator")) then {
			_validator = compile(getText(_x >> "validator"));
		};

		// Add label
		private _label = _display ctrlCreate ["RscText", _idc, _optionsContainer];
		_label ctrlSetText (_title + ":");
		_label ctrlSetTooltip _description;
		_label ctrlSetPosition [_xx, _yy + 0.025 - 0.037/2, RSTF_ADV_OPS_W * 0.4, 0.037];
		_label ctrlCommit 0;

		_idc = _idc + 1;

		// Decide control used for input
		private _ctrlType = "RscEdit";
		switch (_type) do {
			case "checkbox": { _ctrlType = "RscCheckBox"; };
			case "select": { _ctrlType = "RscCombo"; };
		};

		// Build input control
		private _ctrl = _display ctrlCreate [_ctrlType, _idc, _optionsContainer];
		_ctrl ctrlSetText str(_value);
		_ctrl ctrlSetTooltip _description;

		// Checkbox have fixed size and diferent input
		if (_type == "checkbox") then {
			_ctrl ctrlSetPosition [_xx + _width * 0.5, _yy + 0.005, 0.04, 0.04 * safeZoneW / safeZoneH];

			if (typeName(_value) == typeName(true) && { _value }) then {
				_ctrl cbSetChecked true;
			};
		} else {
			_ctrl ctrlSetPosition [_xx + _width * 0.5, _yy, _width * 0.5, 0.05];
		};

		_ctrl ctrlCommit 0;

		// Add values to combo box
		if (_type == "select") then {
			private _selectOptions = if (isArray(_x >> "options")) then { getArray(_x >> "options") } else { [] };
			if (isText(_x >> "optionsVariable")) then {
				_selectOptions = missionNamespace getVariable getText(_x >> "optionsVariable");
			};

			{
				private _itemValue = _foreachIndex;
				private _itemLabel = _x;

				if (typeName(_x) == typeName([])) then {
					_itemValue = _x#0;
					_itemLabel = _x#1;
				};

				_ctrl lbAdd _itemLabel;
				_ctrl lbSetData [_foreachIndex, if (typeName(_itemValue) != typeName("")) then { str(_itemValue) } else { _itemValue }];

				if (typeName(_value) == typeName(_itemValue) && { _itemValue == _value }) then {
					_ctrl lbSetCurSel _foreachIndex;
				};
			} foreach _selectOptions;

			_ctrl ctrlAddEventHandler ["LBSelChanged", {
				0 spawn {
					call RSTF_fnc_saveAdvancedOptions;
					call RSTF_fnc_updateAdvancedConfig;
				}
			}];
		};

		// Add input filtering for numbers
		if (_type == "number") then {
			_ctrl ctrlAddEventHandler ["Char", {
				[_this select 0, _this select 1, "NUMBERS"] call RSTF_fnc_filterInput;
			}];
		};

		// Add input filtering for floats
		if (_type == "float") then {
			_ctrl ctrlAddEventHandler ["Char", {
				[_this select 0, _this select 1, "FLOAT"] call RSTF_fnc_filterInput;
			}];
		};

		// Save created option for later manipulation
		RSTF_ADVANCED_LASTOPTIONS pushBack [_ctrl, _label, _type, _name, _validator, _x];
		_idc = _idc + 1;
	};

	_yy = _yy + 0.08;
} foreach _items;