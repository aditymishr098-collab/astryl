"""Real photos for the missions, spacecraft, surface map, telescope and space station pages.

The pictures are in data/photos/space (fetched once by tools/media/fetch_missions.py). Their
captions are added to spacephotos.INFO here, so spacephotos.figure() can show them with credit.
"""
import spacephotos

# id: (credit, English caption, Hindi caption)
spacephotos.INFO.update({
    # the spacecraft
    'sc-sputnik': ('NSSDC, NASA', 'A copy of Sputnik 1, a metal ball 58 cm wide with four antennas.', 'Sputnik 1 की नक़ल: चार antennas वाली 58 cm चौड़ी धातु की गेंद।'),
    'sc-vostok': ('HPH (Wikimedia Commons)', 'A Vostok spacecraft like the one that carried the first person into space.', 'Vostok यान, वैसा ही जिसने पहले इंसान को अंतरिक्ष पहुँचाया।'),
    'sc-apollo11': ('NASA', 'The Apollo 11 lander Eagle above the Moon, photographed from the command module Columbia.', 'चाँद के ऊपर Apollo 11 का lander Eagle, command module Columbia से खींची तस्वीर।'),
    'sc-viking': ('NASA/JPL-Caltech/University of Arizona', 'A full-size model of the Viking lander.', 'Viking lander का पूरे आकार का model।'),
    'sc-voyager': ('NASA/JPL', 'A Voyager spacecraft (drawing). The big dish sends its signals home.', 'Voyager यान (चित्र)। बड़ी dish उसके signal घर भेजती है।'),
    'sc-hubble': ('NASA (crew of STS-125)', 'Hubble photographed by astronauts during its last repair mission in 2009.', '2009 के आख़िरी मरम्मत mission में astronauts की खींची Hubble की तस्वीर।'),
    'sc-cassini': ('NASA/JPL', 'Cassini arriving at Saturn in 2004 (drawing).', '2004 में शनि पर पहुँचता Cassini (चित्र)।'),
    'sc-curiosity': ('NASA/JPL-Caltech/MSSS', 'Curiosity’s selfie on Mars, made from many photos taken with its robot arm.', 'मंगल पर Curiosity की selfie, उसकी robot बाँह से ली गई कई तस्वीरों से बनी।'),
    'sc-mangalyaan': ('Nesnad (Wikimedia Commons)', 'Mangalyaan around Mars (drawing).', 'मंगल के चारों ओर Mangalyaan (चित्र)।'),
    'sc-rosetta': ('ESA/ATG medialab', 'Rosetta, with its huge solar panels (model).', 'अपने विशाल solar panels के साथ Rosetta (model)।'),
    'sc-newhorizons': ('NASA/JHUAPL', 'New Horizons, about the size of a piano (drawing).', 'New Horizons, लगभग एक piano जितना बड़ा (चित्र)।'),
    'sc-perseverance': ('NASA/JPL-Caltech', 'Perseverance’s selfie on Mars.', 'मंगल पर Perseverance की selfie।'),
    'sc-jwst': ('NASA', 'The James Webb Space Telescope: a gold mirror 6.5 m wide on a sunshield the size of a tennis court.', 'James Webb Space Telescope: tennis court जितनी बड़ी धूप-ढाल पर 6.5 m चौड़ा सुनहरा शीशा।'),
    'sc-chandrayaan3': ('ISRO/Simeon Schmauß', 'Chandrayaan-3’s lander Vikram on the Moon, photographed by the Pragyan rover (processed in 3D).', 'चाँद पर Chandrayaan-3 का lander Vikram, Pragyan rover की खींची तस्वीर (3D में तैयार)।'),
    'sc-aditya': ('ISRO', 'Aditya-L1 being prepared before launch.', 'Launch से पहले तैयार होता Aditya-L1।'),
    'sc-iss': ('NASA', 'The International Space Station, photographed from the Space Shuttle Atlantis in 2010.', 'अंतर्राष्ट्रीय अंतरिक्ष स्टेशन, 2010 में Space Shuttle Atlantis से खींची तस्वीर।'),
    # the pictures they took
    'pic-apollo11': ('NASA', 'A bootprint in the Moon’s dust, photographed during Apollo 11. With no wind, it can last for millions of years.', 'Apollo 11 के दौरान खींचा चाँद की धूल में जूते का निशान। हवा न होने से यह लाखों साल रह सकता है।'),
    'pic-earthrise': ('NASA', '“Earthrise”: Earth rising over the Moon, taken by the Apollo 8 crew in 1968.', '“Earthrise”: चाँद के ऊपर उगती पृथ्वी, 1968 में Apollo 8 के यात्रियों की खींची तस्वीर।'),
    'pic-viking': ('NASA/JPL', 'The first photo from the surface of Mars, taken by Viking 1 minutes after landing on 20 July 1976.', 'मंगल की सतह से पहली तस्वीर, Viking 1 ने 20 जुलाई 1976 को उतरने के कुछ मिनट बाद ली।'),
    'pic-paleblue': ('NASA/JPL', '“Pale Blue Dot” (1990): Earth as a tiny dot in a ray of sunlight, seen by Voyager 1 from 6 billion km away.', '“Pale Blue Dot” (1990): 6 अरब km दूर से Voyager 1 को सूरज की किरण में एक छोटे बिंदु जैसी दिखी पृथ्वी।'),
    'pic-voyager-jupiter': ('NASA', 'Jupiter’s Great Red Spot, photographed by Voyager 1 in 1979.', '1979 में Voyager 1 की खींची बृहस्पति के Great Red Spot की तस्वीर।'),
    'pic-huygens': ('ESA/NASA/JPL/University of Arizona', 'The surface of Titan, photographed by the Huygens probe after it landed in 2005: rounded pebbles of ice.', 'Titan की सतह, 2005 में उतरने के बाद Huygens की खींची तस्वीर: बर्फ़ के गोल कंकड़।'),
    'pic-cassini-earth': ('NASA/JPL/Space Science Institute', 'Saturn with the Sun behind it, photographed by Cassini; its rings glow in the backlight.', 'पीछे सूरज के साथ शनि, Cassini की खींची तस्वीर; पीछे की रोशनी में छल्ले चमकते हैं।'),
    'pic-curiosity': ('NASA/JPL-Caltech/MSSS', 'Curiosity on the slopes of Mount Sharp, a mountain of layered rock in Gale crater.', 'Gale गड्ढे में परतदार चट्टानों के पहाड़ Mount Sharp की ढलान पर Curiosity।'),
    'pic-rosetta': ('ESA/Rosetta/NAVCAM', 'Comet 67P, about 4 km long, photographed by Rosetta in 2014.', 'लगभग 4 km लंबा धूमकेतु 67P, 2014 में Rosetta की खींची तस्वीर।'),
    'pic-pluto': ('NASA/JHUAPL/SwRI', 'Pluto in true colour, photographed by New Horizons in 2015, with its heart-shaped plain.', 'असली रंगों में प्लूटो, 2015 में New Horizons की खींची तस्वीर, दिल के आकार के मैदान के साथ।'),
    'pic-ingenuity': ('NASA/JPL-Caltech/ASU (processed by Simeon Schmauß)', 'The Ingenuity helicopter on Mars, photographed by Perseverance.', 'मंगल पर Ingenuity helicopter, Perseverance की खींची तस्वीर।'),
    # space station
    'iss-india-night': ('NASA', 'Northern India at night, photographed by astronauts on the space station.', 'रात में उत्तरी भारत, अंतरिक्ष स्टेशन के astronauts की खींची तस्वीर।'),
    'iss-cupola': ('NASA/Nichole Ayers', 'A “gigantic jet” of lightning shooting up from a storm, seen from the space station.', 'तूफ़ान से ऊपर उठती बिजली की “gigantic jet”, अंतरिक्ष स्टेशन से दिखी।'),
    'iss-trail': ('NASA Johnson Space Center', 'Earth’s edge from the station: the thin glowing line is airglow in the upper air.', 'स्टेशन से पृथ्वी का किनारा: पतली चमकती लकीर ऊपरी हवा की चमक (airglow) है।'),
    # landing sites from orbit
    'site-Apollo11': ('NASA/GSFC/Arizona State University', 'The Apollo 11 landing site seen from orbit by NASA’s Lunar Reconnaissance Orbiter.', 'NASA के Lunar Reconnaissance Orbiter से कक्षा से दिखी Apollo 11 की उतरने की जगह।'),
    'site-Apollo17': ('NASA/GSFC/Arizona State University', 'The Apollo 17 site from orbit: the lander and the tracks of the astronauts and their rover are visible.', 'कक्षा से Apollo 17 की जगह: lander और astronauts व उनके rover के निशान दिखते हैं।'),
    'site-Chandrayaan3': ('NASA/GSFC/Arizona State University', 'Chandrayaan-3 on the Moon, photographed from orbit by NASA’s Lunar Reconnaissance Orbiter four days after landing (in the box).', 'चाँद पर Chandrayaan-3, उतरने के चार दिन बाद NASA के Lunar Reconnaissance Orbiter की कक्षा से खींची तस्वीर (डिब्बे में)।'),
    'site-Change4': ('NASA/GSFC/Arizona State University', 'Chang’e 4 and its rover on the far side of the Moon (arrows), seen from orbit.', 'चाँद के पिछले हिस्से पर Chang’e 4 और उसका rover (तीर), कक्षा से।'),
    'site-Curiosity': ('NASA/JPL-Caltech/University of Arizona', 'Curiosity driving across Mars, seen from orbit by the HiRISE camera.', 'मंगल पर चलता Curiosity, कक्षा से HiRISE camera की नज़र में।'),
    'site-Perseverance': ('NASA/JPL-Caltech/University of Arizona', 'The route Perseverance has driven across Jezero crater.', 'Jezero गड्ढे में Perseverance का तय किया रास्ता।'),
    # deep sky
    'ds-m42': ('NASA, ESA, M. Robberto and the Hubble Orion Treasury Project Team', 'The Orion Nebula, photographed by Hubble.', 'Hubble की खींची ओरायन नीहारिका।'),
    'ds-m45': ('NASA, ESA, AURA/Caltech, Palomar Observatory', 'The Pleiades star cluster.', 'कृत्तिका तारा समूह।'),
})

# what each mission took (and what took it)
MISSION = {
    'sputnik1': ['sc-sputnik'], 'vostok1': ['sc-vostok'], 'apollo11': ['sc-apollo11', 'pic-apollo11'], 'viking1': ['sc-viking', 'pic-viking'],
    'voyager1': ['sc-voyager', 'pic-paleblue', 'pic-voyager-jupiter'], 'hubble': ['sc-hubble', 'gx-udf', 'ds-m42'],
    'huygens': ['sc-cassini', 'pic-huygens', 'pic-cassini-earth'], 'curiosity': ['sc-curiosity', 'pic-curiosity'],
    'mangalyaan': ['sc-mangalyaan'], 'rosetta': ['sc-rosetta', 'pic-rosetta'], 'newhorizons': ['sc-newhorizons', 'pic-pluto'],
    'perseverance': ['sc-perseverance', 'pic-ingenuity'], 'jwst': ['sc-jwst', 'gx-webb', 'nb-cliffs'], 'chandrayaan3': ['sc-chandrayaan3', 'site-Chandrayaan3'],
}
CRAFT = {
    'voyager1': ['sc-voyager', 'pic-paleblue'], 'voyager2': ['sc-voyager'], 'newhorizons': ['sc-newhorizons', 'pic-pluto'],
    'jwst': ['sc-jwst', 'gx-webb'], 'adityal1': ['sc-aditya'], 'iss': ['sc-iss', 'iss-india-night'], 'hubble': ['sc-hubble', 'gx-udf'],
    'marsrovers': ['sc-curiosity', 'sc-perseverance', 'pic-ingenuity'],
}

spacephotos.SLOTS['iss.html'] = ['sc-iss', 'iss-india-night', 'iss-cupola', 'iss-trail']
