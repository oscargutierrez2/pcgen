/*
 * Copyright (c) 2008 Tom Parker <thpr@users.sourceforge.net>
 * 
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA
 */
package plugin.lsttokens.race;

import pcgen.cdom.base.Constants;
import pcgen.cdom.base.FormulaFactory;
import pcgen.cdom.content.LevelCommandFactory;
import pcgen.cdom.enumeration.ObjectKey;
import pcgen.cdom.reference.CDOMSingleRef;
import pcgen.core.PCClass;
import pcgen.core.Race;
import pcgen.core.utils.ParsingSeparator;
import pcgen.rules.context.LoadContext;
import pcgen.rules.persistence.token.AbstractNonEmptyToken;
import pcgen.rules.persistence.token.CDOMPrimaryParserToken;
import pcgen.rules.persistence.token.DeferredToken;
import pcgen.rules.persistence.token.ParseResult;
import pcgen.util.Logging;

/**
 * Class deals with MONSTERCLASS Token
 */
public class MonsterclassToken extends AbstractNonEmptyToken<Race> implements
		CDOMPrimaryParserToken<Race>, DeferredToken<Race>
{

	private static final Class<PCClass> PCCLASS_CLASS = PCClass.class;

	@Override
	public String getTokenName()
	{
		return "MONSTERCLASS";
	}

	@Override
	protected ParseResult parseNonEmptyToken(LoadContext context, Race race,
		String value)
	{
		ParsingSeparator sep = new ParsingSeparator(value, ':');
		String classString = sep.next();
		if (!sep.hasNext())
		{
			return new ParseResult.Fail(getTokenName() + " must have a colon: "
					+ value);
		}
		String numLevels = sep.next();
		if (sep.hasNext())
		{
			return new ParseResult.Fail(getTokenName() + " must have only one colon: "
					+ value);
		}
		CDOMSingleRef<PCClass> cl = context.ref.getCDOMReference(PCCLASS_CLASS,
				classString);
		try
		{
			int lvls = Integer.parseInt(numLevels);
			if (lvls <= 0)
			{
				return new ParseResult.Fail("Number of levels in " + getTokenName()
						+ " must be greater than zero: " + value);
			}
			LevelCommandFactory cf = new LevelCommandFactory(cl, FormulaFactory
					.getFormulaFor(lvls));
			context.getObjectContext().put(race, ObjectKey.MONSTER_CLASS, cf);
			return ParseResult.SUCCESS;
		}
		catch (NumberFormatException nfe)
		{
			return new ParseResult.Fail("Number of levels in " + getTokenName()
					+ " must be an integer greater than zero: " + value);
		}
	}

	public String[] unparse(LoadContext context, Race race)
	{
		LevelCommandFactory lcf = context.getObjectContext().getObject(race,
				ObjectKey.MONSTER_CLASS);
		if (lcf == null)
		{
			return null;
		}
		StringBuilder sb = new StringBuilder();
		sb.append(lcf.getLSTformat()).append(Constants.COLON).append(
				lcf.getLevelCount().toString());
		return new String[] { sb.toString() };
	}

	public Class<Race> getTokenClass()
	{
		return Race.class;
	}

	public Class<Race> getDeferredTokenClass()
	{
		return Race.class;
	}

	public boolean process(LoadContext context, Race r)
	{
		LevelCommandFactory lcf = r.get(ObjectKey.MONSTER_CLASS);
		if (lcf != null)
		{
			String className = lcf.getLSTformat();
			PCClass pcc = context.ref.silentlyGetConstructedCDOMObject(
					PCCLASS_CLASS, className);
			if (pcc != null && !pcc.isMonster())
			{
				Logging.log(Logging.LST_WARNING, "Class " + className
						+ " was used in RACE MONSTERCLASS, "
						+ "but it is not a Monster class");
			}
		}
		return true;
	}
}
