import { BaseAny } from 'vs/workbench/parts/maix/fpioa-config/common/baseAny';

export enum ChipPackageType {
	BGA = 1, // left top is 0
}

export type PIN_POWER = -1;
export type PIN_NC = -2;
export type PIN_SPECIAL = -3;

export const PIN_POWER: PIN_POWER = -1;
export const PIN_NC: PIN_NC = -2;
export const PIN_SPECIAL: PIN_SPECIAL = -3;

export type PIN_IO = number;
export type PinId = PIN_IO | PIN_NC | PIN_POWER;

export interface IFuncPin {
	name: string;
	funcNumber: number;
	ignoreFnName?: boolean;
	description?: string;
}

export interface IFunc {
	name: string;
	ios: IFuncPin[];
	description?: string;
}

export interface IPin2D {
	x: number;
	y: string | number;
}

export interface IPin2DNumber {
	x: number;
	y: number;
}

export type IPin = string | number | IPin2D;

export interface IPinRange {
	from: IPin;
	to: IPin;
}

export interface IOPinPlacement { // { A1: IO1, B2: IO2 ... }
	[pinLocation: string]: /* pinIO: */number;
}

export interface IOPinPlacementRevert {
	[pinIO: number]: /* pinLocation: */string;
}

export interface IChipGeometry {
	type: number; // ChipPackageType
	maxPin: {
		name: string;
		x: number;
		y: number;
	};
	emptyRange?: IPinRange[];
	missingRows: string; // I S O X Y
	IOPinPlacement: IOPinPlacement;
}

export interface IChipGeneratorConfig {
	funcNamePrefix: string;
	setterFuncName: string;
	libraryName: string;
}

export interface IChipPackagingDefine {
	name: string;
	geometry: IChipGeometry;
	usableFunctions: IFunc[];
	generator: IChipGeneratorConfig; // TODO
}

//   export  type IFunctionMapping = Map<IFuncItem, (PinId | undefined)[]>;

export interface IChipPackagingCalculated extends IChipPackagingDefine {
	pinCount: number;
	ROW: BaseAny;
}