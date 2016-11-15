package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;

import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.Utils;

import openfl.ui.Mouse;
import openfl.display.Graphics;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;
import box2D.collision.shapes.B2Shape;

import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;



class Design_14_14_IntroTitle extends SceneScript
{
	public var _Started:Bool;
	public var _FontToUse:Font;
	public var _TimeBeforeRetreat:Float;
	public var _YCentrePosition:Float;
	public var _AlternativeText:String;
	public var _SlideSpeed:Float;
	public var _DrawRectangle:Bool;
	public var _XCentrePosition:Float;
	public var _FillColour:Int;
	public var _StrokeColour:Int;
	public var _StrokeThickness:Float;
	public var _Padding:Float;
	public var _Rounding:Float;
	public var _SlideDirection:String;
	public var _SlideSpeedChange:Float;
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("Started", "_Started");
		_Started = false;
		nameMap.set("Font To Use", "_FontToUse");
		nameMap.set("Time Before Retreat", "_TimeBeforeRetreat");
		_TimeBeforeRetreat = 1.0;
		nameMap.set("Y Centre Position", "_YCentrePosition");
		_YCentrePosition = 0.0;
		nameMap.set("Alternative Text", "_AlternativeText");
		_AlternativeText = "";
		nameMap.set("Slide Speed", "_SlideSpeed");
		_SlideSpeed = -5.0;
		nameMap.set("Draw Rounded Rectangle?", "_DrawRectangle");
		_DrawRectangle = false;
		nameMap.set("X Centre Position", "_XCentrePosition");
		_XCentrePosition = 0.0;
		nameMap.set("Fill Colour", "_FillColour");
		_FillColour = Utils.getColorRGB(204,255,255);
		nameMap.set("Stroke Colour", "_StrokeColour");
		_StrokeColour = Utils.getColorRGB(153,204,255);
		nameMap.set("Stroke Thickness", "_StrokeThickness");
		_StrokeThickness = 1.0;
		nameMap.set("Padding", "_Padding");
		_Padding = 4.0;
		nameMap.set("Rounding", "_Rounding");
		_Rounding = 2.0;
		nameMap.set("Slide Direction", "_SlideDirection");
		_SlideDirection = "";
		nameMap.set("Slide Speed Change", "_SlideSpeedChange");
		_SlideSpeedChange = 0.5;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_Started = false;
		propertyChanged("_Started", _Started);
		runLater(1000 * _TimeBeforeRetreat, function(timeTask:TimedTask):Void {
			_Started = true;
			propertyChanged("_Started", _Started);
		}, null);
		if(((!hasValue(_AlternativeText)) || (("" + _AlternativeText).length == 0)))
		{
			_AlternativeText = getCurrentSceneName();
			propertyChanged("_AlternativeText", _AlternativeText);
		}
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(_Started)
				{
					if((_SlideDirection == "Up"))
					{
						_YCentrePosition -= _SlideSpeed;
						propertyChanged("_YCentrePosition", _YCentrePosition);
					}
					else if((_SlideDirection == "Down"))
					{
						_YCentrePosition += _SlideSpeed;
						propertyChanged("_YCentrePosition", _YCentrePosition);
					}
					else if((_SlideDirection == "Left"))
					{
						_XCentrePosition -= _SlideSpeed;
						propertyChanged("_XCentrePosition", _XCentrePosition);
					}
					else if((_SlideDirection == "Right"))
					{
						_XCentrePosition += _SlideSpeed;
						propertyChanged("_XCentrePosition", _XCentrePosition);
					}
					_SlideSpeed += _SlideSpeedChange;
					propertyChanged("_SlideSpeed", _SlideSpeed);
				}
			}
		});
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				g.alpha = ((100 - Math.abs(_SlideSpeed))/100);
				g.setFont(_FontToUse);
				if(_DrawRectangle)
				{
					g.fillColor = _FillColour;
					g.strokeColor = _StrokeColour;
					g.strokeSize = Std.int(_StrokeThickness);
					g.fillRoundRect((_XCentrePosition - ((g.font.font.getTextWidth(_AlternativeText)/Engine.SCALE / 2) + _Padding)), (_YCentrePosition - ((g.font.getHeight()/Engine.SCALE / 2) + _Padding)), (g.font.font.getTextWidth(_AlternativeText)/Engine.SCALE + (_Padding * 2)), (g.font.getHeight()/Engine.SCALE + (_Padding * 2)), _Rounding);
					g.drawRoundRect((_XCentrePosition - ((g.font.font.getTextWidth(_AlternativeText)/Engine.SCALE / 2) + _Padding)), (_YCentrePosition - ((g.font.getHeight()/Engine.SCALE / 2) + _Padding)), (g.font.font.getTextWidth(_AlternativeText)/Engine.SCALE + (_Padding * 2)), (g.font.getHeight()/Engine.SCALE + (_Padding * 2)), _Rounding);
				}
				g.drawString("" + _AlternativeText, (_XCentrePosition - (g.font.font.getTextWidth(_AlternativeText)/Engine.SCALE / 2)), (_YCentrePosition - (g.font.getHeight()/Engine.SCALE / 2)));
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}