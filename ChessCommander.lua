--[[----------------------------------------------
Chess Commander
Author: Static_Recharge
Version: 0.1.0
Date Last Modified: 2021/08/07
Description: Allows 2 players to engage in a game
of chess using a gameboard and pieces created
within a player's house.
----------------------------------------------]]--


--[[----------------------------------------------
Addon Information
----------------------------------------------]]--
local CC = {
  addonName = "ChessCommander",
  version = "0.1.0",
  author = "Static_Recharge",
  varsVersion = 2,
}


--[[----------------------------------------------
Variable, Table and Constant Declarations
----------------------------------------------]]--
CC.Const = {
  chatPrefix = "|c6699FF[Chess Commander]: |cFFFFFF",
  chatSuffix = "|r",
  pawn = 1,
  rook = 2,
  knight = 3,
  bishop = 4,
  queen = 5,
  king = 6,
  white = 1,
  black = 2,
  stepSize = 50,
  stepDelay = 100,
  A = 1,
  B = 2,
  C = 3,
  D = 4,
  E = 5,
  F = 6,
  G = 7,
  H = 8,
}

CC.Que = {
  step = nil,
  Callback = nil
}

CC.Defaults = {
  Grid = {},
  PieceIDs = {},
  Prison = {White = {}, Black = {}},
  boardSetup = false,
  piecesSetup = false,
  Squares = {
    [1] = {[1] = "WQR", [2] = "WP1", [3] = nil, [4] = nil, [5] = nil, [6] = nil, [7] = "BP1", [8] = "BQR"},
    [2] = {[1] = "WQN", [2] = "WP2", [3] = nil, [4] = nil, [5] = nil, [6] = nil, [7] = "BP2", [8] = "BQN"},
    [3] = {[1] = "WQB", [2] = "WP3", [3] = nil, [4] = nil, [5] = nil, [6] = nil, [7] = "BP3", [8] = "BQB"},
    [4] = {[1] = "WQ", [2] = "WP4", [3] = nil, [4] = nil, [5] = nil, [6] = nil, [7] = "BP4", [8] = "BQ"},
    [5] = {[1] = "WK", [2] = "WP5", [3] = nil, [4] = nil, [5] = nil, [6] = nil, [7] = "BP5", [8] = "BK"},
    [6] = {[1] = "WKB", [2] = "WP6", [3] = nil, [4] = nil, [5] = nil, [6] = nil, [7] = "BP6", [8] = "BKB"},
    [7] = {[1] = "WKN", [2] = "WP7", [3] = nil, [4] = nil, [5] = nil, [6] = nil, [7] = "BP7", [8] = "BKN"},
    [8] = {[1] = "WKR", [2] = "WP8", [3] = nil, [4] = nil, [5] = nil, [6] = nil, [7] = "BP8", [8] = "BKR"},
  },
  Pieces = {
    -- Stores all of the data for the game pieces
    -- type determines the type of piece (see constants)
    -- lName is the longhand name of the piece
    -- sName is the shorthand name of the piece aka nickname, same as the index for the piece
    -- startX/Y are the starting squares of the pieces, use the Grid table to look up coordinates
    -- color is the text version of the pieces color based on constants
    -- x/y is the current square the piece is on
    -- numMoves is the total times the piece was moved over the course of the game
    -- captured indicates if the piece is in prison or not
    -- enPassant indicates if the piece has an En passant capture available on the current turn
    WKR = {type = CC.Const.rook, lName = "White King's Rook", sName = "WKR", startX = 8, startY = 1, color = CC.Const.white, x = 8, y = 1, numMoves = 0, captured = false},
    WKN = {type = CC.Const.knight, lName = "White King's Knight", sName = "WKN", startX = 7, startY = 1, color = CC.Const.white, x = 7, y = 1, numMoves = 0, captured = false},
    WKB = {type = CC.Const.bishop, lName = "White King's Bishop", sName = "WKB", startX = 6, startY = 1, color = CC.Const.white, x = 6, y = 1, numMoves = 0, captured = false},
    WK = {type = CC.Const.king, lName = "White King", sName = "WK", startX = 5, startY = 1, color = CC.Const.white, x = 5, y = 1, numMoves = 0, captured = false},
    WQ = {type = CC.Const.queen, lName = "White Queen", sName = "WQ", startX = 4, startY = 1, color = CC.Const.white, x = 4, y = 1, numMoves = 0, captured = false},
    WQB = {type = CC.Const.bishop, lName = "White Queen's Bishop", sName = "WQB", startX = 3, startY = 1, color = CC.Const.white, x = 3, y = 1, numMoves = 0, captured = false},
    WQN = {type = CC.Const.knight, lName = "White Queens' Knight", sName = "WQN", startX = 2, startY = 1, color = CC.Const.white, x = 2, y = 1, numMoves = 0, captured = false},
    WQR = {type = CC.Const.rook, lName = "White Queen's Rook", sName = "WQR", startX = 1, startY = 1, color = CC.Const.white, x = 1, y = 1, numMoves = 0, captured = false},
    WP1 = {type = CC.Const.pawn, lName = "White Pawn 1", sName = "WP1", startX = 1, startY = 2, color = CC.Const.white, x = 1, y = 2, numMoves = 0, captured = false, enPassant = false},
    WP2 = {type = CC.Const.pawn, lName = "White Pawn 2", sName = "WP2", startX = 2, startY = 2, color = CC.Const.white, x = 2, y = 2, numMoves = 0, captured = false, enPassant = false},
    WP3 = {type = CC.Const.pawn, lName = "White Pawn 3", sName = "WP3", startX = 3, startY = 2, color = CC.Const.white, x = 3, y = 2, numMoves = 0, captured = false, enPassant = false},
    WP4 = {type = CC.Const.pawn, lName = "White Pawn 4", sName = "WP4", startX = 4, startY = 2, color = CC.Const.white, x = 4, y = 2, numMoves = 0, captured = false, enPassant = false},
    WP5 = {type = CC.Const.pawn, lName = "White Pawn 5", sName = "WP5", startX = 5, startY = 2, color = CC.Const.white, x = 5, y = 2, numMoves = 0, captured = false, enPassant = false},
    WP6 = {type = CC.Const.pawn, lName = "White Pawn 6", sName = "WP6", startX = 6, startY = 2, color = CC.Const.white, x = 6, y = 2, numMoves = 0, captured = false, enPassant = false},
    WP7 = {type = CC.Const.pawn, lName = "White Pawn 7", sName = "WP7", startX = 7, startY = 2, color = CC.Const.white, x = 7, y = 2, numMoves = 0, captured = false, enPassant = false},
    WP8 = {type = CC.Const.pawn, lName = "White Pawn 8", sName = "WP8", startX = 8, startY = 2, color = CC.Const.white, x = 8, y = 2, numMoves = 0, captured = false, enPassant = false},
    BKR = {type = CC.Const.rook, lName = "Black King's Rook", sName = "BKR", startX = 8, startY = 8, color = CC.Const.black, x = 8, y = 8, numMoves = 0, captured = false},
    BKN = {type = CC.Const.knight, lName = "Black King's Knight", sName = "BKB", startX = 7, startY = 8, color = CC.Const.black, x = 7, y = 8, numMoves = 0, captured = false},
    BKB = {type = CC.Const.bishop, lName = "Black King's Bishop", sName = "BKB", startX = 6, startY = 8, color = CC.Const.black, x = 6, y = 8, numMoves = 0, captured = false},
    BK = {type = CC.Const.king, lName = "Black King", sName = "BK", startX = 5, startY = 8, color = CC.Const.black, x = 5, y = 8, numMoves = 0, captured = false},
    BQ = {type = CC.Const.queen, lName = "Black Queen", sName = "BQ", startX = 4, startY = 8, color = CC.Const.black, x = 4, y = 8, numMoves = 0, captured = false},
    BQB = {type = CC.Const.bishop, lName = "Black Queen's Bishop", sName = "BQB", startX = 3, startY = 8, color = CC.Const.black, x = 3, y = 8, numMoves = 0, captured = false},
    BQN = {type = CC.Const.knight, lName = "Black Queen's' Knight", sName = "BQN", startX = 2, startY = 8, color = CC.Const.black, x = 2, y = 8, numMoves = 0, captured = false},
    BQR = {type = CC.Const.rook, lName = "Black Queen's Rook", sName = "BQR", startX = 1, startY = 8, color = CC.Const.black, x = 1, y = 8, numMoves = 0, captured = false},
    BP1 = {type = CC.Const.pawn, lName = "Black Pawn 1", sName = "BP1", startX = 1, startY = 7, color = CC.Const.black, x = 1, y = 7, numMoves = 0, captured = false, enPassant = false},
    BP2 = {type = CC.Const.pawn, lName = "Black Pawn 2", sName = "BP2", startX = 2, startY = 7, color = CC.Const.black, x = 2, y = 7, numMoves = 0, captured = false, enPassant = false},
    BP3 = {type = CC.Const.pawn, lName = "Black Pawn 3", sName = "BP3", startX = 3, startY = 7, color = CC.Const.black, x = 3, y = 7, numMoves = 0, captured = false, enPassant = false},
    BP4 = {type = CC.Const.pawn, lName = "Black Pawn 4", sName = "BP4", startX = 4, startY = 7, color = CC.Const.black, x = 4, y = 7, numMoves = 0, captured = false, enPassant = false},
    BP5 = {type = CC.Const.pawn, lName = "Black Pawn 5", sName = "BP5", startX = 5, startY = 7, color = CC.Const.black, x = 5, y = 7, numMoves = 0, captured = false, enPassant = false},
    BP6 = {type = CC.Const.pawn, lName = "Black Pawn 6", sName = "BP6", startX = 6, startY = 7, color = CC.Const.black, x = 6, y = 7, numMoves = 0, captured = false, enPassant = false},
    BP7 = {type = CC.Const.pawn, lName = "Black Pawn 7", sName = "BP7", startX = 7, startY = 7, color = CC.Const.black, x = 7, y = 7, numMoves = 0, captured = false, enPassant = false},
    BP8 = {type = CC.Const.pawn, lName = "Black Pawn 8", sName = "BP8", startX = 8, startY = 7, color = CC.Const.black, x = 8, y = 7, numMoves = 0, captured = false, enPassant = false},
  }
}
CC.Game = {
  Squares = {}
}
CC.Board = {
  Init = {},
  Grid = {},
}
CC.Prison = {
  White = {},
  Black = {},
}
CC.Pieces = {}
CC.epPair = {Move = {}, Capture = {}}


--[[----------------------------------------------
Aliases
----------------------------------------------]]--
local EM = EVENT_MANAGER
local CS = CHAT_SYSTEM
local SM = SCENE_MANAGER


--[[----------------------------------------------
General Functions
----------------------------------------------]]--
function CC.SendToChat(text)
  if text ~= nil then
    CS:AddMessage(CC.Const.chatPrefix .. text .. CC.Const.chatSuffix)
  else
    CS:AddMessage(CC.Const.chatPrefix .. "nil string" .. CC.Const.chatSuffix)
  end
end

function CC.Test(piece)
  CC.Game.Capture(piece)
end

function CC.Debug()
  d(CC.Prison)
end

function CC.GetPieceFurnitureInfo()
  if GetHousingEditorMode() ~= 2 then CC.SendToChat("Please make sure you're in selection mode in the housing editor.") return end
  local ID = HousingEditorGetTargetInfo()
  local name = GetPlacedHousingFurnitureInfo(ID)
  local x, worldY, y = HousingEditorGetFurnitureWorldPosition(ID)
  local Piece = {ID = ID, name = name, worldY = worldY}
  return Piece
end


--[[----------------------------------------------
Chess Game Management
----------------------------------------------]]--

function CC.Game.MoveIterator(piece, Path, i, worldY)
  --CC.SendToChat("interX: " .. interX .. ", interY: " .. interY)
  HousingEditorRequestChangePosition(piece, Path[i].x, worldY, Path[i].y)
  i = i + 1
  if i <= #Path then
    zo_callLater(function() CC.Game.MoveIterator(piece, Path, i, worldY) end, CC.Const.stepDelay)
  end
end

function CC.Game.Move(piece, dest, override)
  if not override then
    local Moves = CC.Game.FindAllowedMoves(piece)
    if not Moves[dest.x][dest.y] then CC.SendToChat("Invalid destination for " .. piece) return end
    if CC.Pieces[piece].captured then CC.SendToChat(piece .. " is captured.") return end -- not a valid piece, it is in prison
  end
  local x, worldY, y = HousingEditorGetFurnitureWorldPosition(CC.Pieces[piece].ID)
  local distance = math.sqrt(math.pow((CC.Board.Grid[dest.x][dest.y].x - x), 2) + math.pow((CC.Board.Grid[dest.x][dest.y].y - y), 2))
  local numSteps = math.floor(distance / CC.Const.stepSize)
  local theta = math.atan2((CC.Board.Grid[dest.x][dest.y].y - y), (CC.Board.Grid[dest.x][dest.y].x - x))
  local xStep = CC.Const.stepSize * math.cos(theta)
  local yStep = CC.Const.stepSize * math.sin(theta)
  local Path = {}
  --CC.SendToChat("x: " .. x .. ", y: " .. y .. ", numSteps: " .. numSteps .. ", distance: " .. distance)
  --CC.SendToChat("dest.x: " .. dest.x .. ", dest.y: " .. dest.y)
  for i=1, numSteps do Path[i] = {x = (xStep * i) + x, y = (yStep * i) + y} end
  Path[numSteps + 1] = {x = CC.Board.Grid[dest.x][dest.y].x, y = CC.Board.Grid[dest.x][dest.y].y}
  CC.Game.MoveIterator(CC.Pieces[piece].ID, Path, 1, worldY)
  if CC.Game.Squares[dest.x][dest.y] ~= nil then CC.Game.Capture(CC.Game.Squares[dest.x][dest.y]) end
  if CC.Pieces[piece].enPassant then
    if (dest.x == CC.epPair.Move.x) and (dest.y == CC.epPair.Move.y) then
      CC.Game.Capture(CC.Game.Squares[CC.epPair.Capture.x][CC.epPair.Capture.y])
    end
  end
  for i,v in pairs(CC.Pieces) do
    if v.type == CC.Const.pawn then
      v.enPassant = false
    end
  end
  CC.epPair.Move = {}
  CC.epPair.Capture = {}
  CC.Game.Squares[dest.x][dest.y] = piece
  CC.Game.Squares[CC.Pieces[piece].x][CC.Pieces[piece].y] = nil
  CC.Pieces[piece].x = dest.x
  CC.Pieces[piece].y = dest.y
  CC.Pieces[piece].numMoves = CC.Pieces[piece].numMoves + 1
  --d(CC.Game.Squares)
end

function CC.Game.FindAllowedMoves(piece)
  local xCurrent, yCurrent = CC.Pieces[piece].x, CC.Pieces[piece].y
  local type = CC.Pieces[piece].type
  local color = CC.Pieces[piece].color
  local numMoves = CC.Pieces[piece].numMoves
  local captured = CC.Pieces[piece].captured
  local forward = nil
  if color == CC.Const.white then forward = 1 else forward = -1 end
  local Moves = {[1] = {}, [2] = {}, [3] = {}, [4] = {}, [5] = {}, [6] = {}, [7] = {}, [8] = {}}

  --[[ Pawn movement logic
  -- Can move up to 2 spaces forward on the piece's first move, otherwise only 1 space forward. Can't jump any pieces.
  -- Captures by moving diagonally forward either left or right 1 space, can only move this way while capturing.
  -- En passant capture *from wikipedia*: "When a pawn advances two squares from its original square and ends the turn adjacent to a pawn of the opponent's on the same rank, it may be captured by that pawn of the opponent's, as if it had moved only one square forward. This capture is only legal on the opponent's next move immediately following the first pawn's advance. The diagrams on the right demonstrate an instance of this: if the white pawn moves from a2 to a4, the black pawn on b4 can capture it en passant, moving from b4 to a3 while the white pawn on a4 is removed from the board." ]]--
  if type == CC.Const.pawn then
    -- basic movement logic
    if (CC.Game.Squares[xCurrent][yCurrent + forward] == nil) and ((yCurrent + forward) <= 8) and ((yCurrent + forward) >= 1) then
      Moves[xCurrent][yCurrent + forward] = true
      if numMoves == 0 then
        if (CC.Game.Squares[xCurrent][yCurrent + (forward*2)] == nil) and ((yCurrent + (forward*2)) <= 8) and ((yCurrent + (forward*2)) >= 1) then
          Moves[xCurrent][yCurrent + (forward*2)] = true
        end
      end
    end
    -- basic capture movement logic
    if ((xCurrent + 1) <= 8) and ((yCurrent + forward) <= 8) and ((yCurrent + forward) >= 1) then
      if (CC.Game.Squares[xCurrent + 1][yCurrent + forward] ~= nil) then
        local target = CC.Pieces[CC.Game.Squares[xCurrent + 1][yCurrent + forward]]
        if target.color ~= color and target.type ~= CC.Const.king then
          Moves[xCurrent + 1][yCurrent + forward] = true
        end
      end
    end
    if ((xCurrent - 1) >= 1) and ((yCurrent + forward) <= 8) and ((yCurrent + forward) >= 1) then
      if (CC.Game.Squares[xCurrent - 1][yCurrent + forward] ~= nil) then
        local target = CC.Pieces[CC.Game.Squares[xCurrent - 1][yCurrent + forward]]
        if target.color ~= color and target.type ~= CC.Const.king then
          Moves[xCurrent - 1][yCurrent + forward] = true
        end
      end
    end
    -- En passant capture movement logic
    if (xCurrent - 1) >= 1 then
      if (CC.Game.Squares[xCurrent - 1][yCurrent] ~= nil) then
        local target = CC.Pieces[CC.Game.Squares[xCurrent - 1][yCurrent]]
        if target.color ~= color and target.numMoves == 1 and target.type == CC.Const.pawn then
          Moves[xCurrent - 1][yCurrent + forward] = true
          CC.Pieces[piece].enPassant = true
          CC.epPair.Move.x = xCurrent - 1
          CC.epPair.Move.y = yCurrent + forward
          CC.epPair.Capture.x = xCurrent - 1
          CC.epPair.Capture.y = yCurrent
        end
      end
    end
    if (xCurrent + 1) <= 8 then
      if (CC.Game.Squares[xCurrent + 1][yCurrent] ~= nil) then
        local target = CC.Pieces[CC.Game.Squares[xCurrent + 1][yCurrent]]
        if target.color ~= color and target.numMoves == 1 and target.type == CC.Const.pawn then
          Moves[xCurrent + 1][yCurrent + forward] = true
          CC.Pieces[piece].enPassant = true
          CC.epPair.Move.x = xCurrent + 1
          CC.epPair.Move.y = yCurrent + forward
          CC.epPair.Capture.x = xCurrent + 1
          CC.epPair.Capture.y = yCurrent
        end
      end
    end

  --[[ Rook movement logic
  -- Can move any number of spaces straight forward or backward, left or right. Can't jump any pieces.
  -- Captures by moving onto an enemy square, movement stops at the capture point. ]]--
  elseif type == CC.Const.rook then
    -- positive x direction
    for i=xCurrent+1, 8, 1 do
      if CC.Game.Squares[i][yCurrent] == nil then Moves[i][yCurrent] = true
      elseif CC.Game.Squares[i][yCurrent] ~= nil and CC.Pieces[CC.Game.Squares[i][yCurrent]].color ~= color and CC.Pieces[CC.Game.Squares[i][yCurrent]].type ~= CC.Const.king then
        Moves[i][yCurrent] = true
        break
      else
        break
      end
    end
    -- negative x direction
    for i=xCurrent-1, 1, -1 do
      if CC.Game.Squares[i][yCurrent] == nil then Moves[i][yCurrent] = true
      elseif CC.Game.Squares[i][yCurrent] ~= nil and CC.Pieces[CC.Game.Squares[i][yCurrent]].color ~= color and CC.Pieces[CC.Game.Squares[i][yCurrent]].type ~= CC.Const.king then
        Moves[i][yCurrent] = true
        break
      else
        break
      end
    end
    -- positive y direction
    for i=yCurrent+1, 8, 1 do
      if CC.Game.Squares[xCurrent][i] == nil then Moves[xCurrent][i] = true
      elseif CC.Game.Squares[xCurrent][i] ~= nil and CC.Pieces[CC.Game.Squares[xCurrent][i]].color ~= color and CC.Pieces[CC.Game.Squares[xCurrent][i]].type ~= CC.Const.king then
        Moves[xCurrent][i] = true
        break
      else
        break
      end
    end
    -- negative y direction
    for i=yCurrent-1, 1, -1 do
      if CC.Game.Squares[xCurrent][i] == nil then Moves[xCurrent][i] = true
      elseif CC.Game.Squares[xCurrent][i] ~= nil and CC.Pieces[CC.Game.Squares[xCurrent][i]].color ~= color and CC.Pieces[CC.Game.Squares[xCurrent][i]].type ~= CC.Const.king then
        Moves[xCurrent][i] = true
        break
      else
        break
      end
    end

  --[[ Knight movement logic
  -- Moves in an 'L' shape, either 1 square and 2 perpendicular or 2 and 1. Can jump other pieces.
  -- Captures on the squares it lands on. ]]--
  elseif type == CC.Const.knight then
    if ((xCurrent + 2) <= 8) and ((yCurrent + 1) <= 8) then
      if CC.Game.Squares[xCurrent + 2][yCurrent + 1] == nil then
        Moves[xCurrent + 2][yCurrent + 1] = true
      elseif CC.Pieces[CC.Game.Squares[xCurrent + 2][yCurrent + 1]].type ~= CC.Const.king then
        Moves[xCurrent + 2][yCurrent + 1] = true
      end
    end
    if ((xCurrent + 2) <= 8) and ((yCurrent - 1) >= 1) then
      if CC.Game.Squares[xCurrent + 2][yCurrent - 1] == nil then
        Moves[xCurrent + 2][yCurrent - 1] = true
      elseif CC.Pieces[CC.Game.Squares[xCurrent + 2][yCurrent - 1]].type ~= CC.Const.king then
        Moves[xCurrent + 2][yCurrent - 1] = true
      end
    end
    if ((xCurrent - 2) >= 1) and ((yCurrent + 1) <= 8) then
      if CC.Game.Squares[xCurrent - 2][yCurrent + 1] == nil then
        Moves[xCurrent - 2][yCurrent + 1] = true
      elseif CC.Pieces[CC.Game.Squares[xCurrent - 2][yCurrent + 1]].type ~= CC.Const.king then
        Moves[xCurrent - 2][yCurrent + 1] = true
      end
    end
    if ((xCurrent - 2) >= 1) and ((yCurrent - 1) >= 1) then
      if CC.Game.Squares[xCurrent - 2][yCurrent - 1] == nil then
        Moves[xCurrent - 2][yCurrent - 1] = true
      elseif CC.Pieces[CC.Game.Squares[xCurrent - 2][yCurrent - 1]].type ~= CC.Const.king then
        Moves[xCurrent - 2][yCurrent - 1] = true
      end
    end
    if ((xCurrent + 1) <= 8) and ((yCurrent + 2) <= 8) then
      if CC.Game.Squares[xCurrent + 1][yCurrent + 2] == nil then
        Moves[xCurrent + 1][yCurrent + 2] = true
      elseif CC.Pieces[CC.Game.Squares[xCurrent + 1][yCurrent + 2]].type ~= CC.Const.king then
        Moves[xCurrent + 1][yCurrent + 2] = true
      end
    end
    if ((xCurrent + 1) <= 8) and ((yCurrent - 2) >= 1) then
      if CC.Game.Squares[xCurrent + 1][yCurrent - 2] == nil then
        Moves[xCurrent + 1][yCurrent - 2] = true
      elseif CC.Pieces[CC.Game.Squares[xCurrent + 1][yCurrent - 2]].type ~= CC.Const.king then
        Moves[xCurrent + 1][yCurrent - 2] = true
      end
    end
    if ((xCurrent - 1) >= 1) and ((yCurrent + 2) <= 8) then
      if CC.Game.Squares[xCurrent - 1][yCurrent + 2] == nil then
        Moves[xCurrent - 1][yCurrent + 2] = true
      elseif CC.Pieces[CC.Game.Squares[xCurrent - 1][yCurrent + 2]].type ~= CC.Const.king then
        Moves[xCurrent - 1][yCurrent + 2] = true
      end
    end
    if ((xCurrent - 1) >= 1) and ((yCurrent - 2) >= 1) then
      if CC.Game.Squares[xCurrent - 1][yCurrent - 2] == nil then
        Moves[xCurrent - 1][yCurrent - 2] = true
      elseif CC.Pieces[CC.Game.Squares[xCurrent - 1][yCurrent - 2]].type ~= CC.Const.king then
        Moves[xCurrent - 1][yCurrent - 2] = true
      end
    end

  --[[ Bishop movement logic
  -- Moves on the diagonals only, can move any number of spaces. Can't jump other pieces.
  -- Captures on squares it lands on, movement stops after capture. ]]--
  elseif type == CC.Const.bishop then
    -- positive x and y
    local j = 1
    for i=xCurrent+1, 8, 1 do
      if (CC.Game.Squares[i][yCurrent + j] == nil) and ((yCurrent + j) <= 8) then
        Moves[i][yCurrent + j] = true
      elseif CC.Game.Squares[i][yCurrent + j] ~= nil and ((yCurrent + j) <= 8) and CC.Pieces[CC.Game.Squares[i][yCurrent + j]].color ~= color and CC.Pieces[CC.Game.Squares[i][yCurrent + j]].type ~= CC.Const.king then
        Moves[i][yCurrent + j] = true
        break
      else
        break
      end
      j = j + 1
    end
    -- positive x and negative y
    j = 1
    for i=xCurrent+1, 8, 1 do
      if (CC.Game.Squares[i][yCurrent - j] == nil) and ((yCurrent - j) <= 8) then
        Moves[i][yCurrent - j] = true
      elseif CC.Game.Squares[i][yCurrent - j] ~= nil and ((yCurrent - j) <= 8) and CC.Pieces[CC.Game.Squares[i][yCurrent - j]].color ~= color and CC.Pieces[CC.Game.Squares[i][yCurrent - j]].type ~= CC.Const.king then
        Moves[i][yCurrent - j] = true
        break
      else
        break
      end
      j = j + 1
    end
    -- negative x and positive y
    j = 1
    for i=xCurrent-1, 1, -1 do
      if (CC.Game.Squares[i][yCurrent + j] == nil) and ((yCurrent + j) <= 8) then
        Moves[i][yCurrent + j] = true
      elseif CC.Game.Squares[i][yCurrent + j] ~= nil and ((yCurrent + j) <= 8) and CC.Pieces[CC.Game.Squares[i][yCurrent + j]].color ~= color and CC.Pieces[CC.Game.Squares[i][yCurrent + j]].type ~= CC.Const.king then
        Moves[i][yCurrent + j] = true
        break
      else
        break
      end
      j = j + 1
    end
    -- negative x and y
    j = 1
    for i=xCurrent-1, 1, -1 do
      if (CC.Game.Squares[i][yCurrent - j] == nil) and ((yCurrent - j) <= 8) then
        Moves[i][yCurrent - j] = true
      elseif CC.Game.Squares[i][yCurrent - j] ~= nil and ((yCurrent - j) <= 8) and CC.Pieces[CC.Game.Squares[i][yCurrent - j]].color ~= color and CC.Pieces[CC.Game.Squares[i][yCurrent - j]].type ~= CC.Const.king then
        Moves[i][yCurrent - j] = true
        break
      else
        break
      end
      j = j + 1
    end

  --[[ Queen movement logic
  -- Moves like a rook and a bishop combined. Can't jump pieces.
  -- Captures on squares that it lands on. ]]--
  elseif type == CC.Const.queen then
    -- positive x direction
    for i=xCurrent+1, 8, 1 do
      if CC.Game.Squares[i][yCurrent] == nil then Moves[i][yCurrent] = true
      elseif CC.Game.Squares[i][yCurrent] ~= nil and CC.Pieces[CC.Game.Squares[i][yCurrent]].color ~= color and CC.Pieces[CC.Game.Squares[i][yCurrent]].type ~= CC.Const.king then
        Moves[i][yCurrent] = true
        break
      else
        break
      end
    end
    -- negative x direction
    for i=xCurrent-1, 1, -1 do
      if CC.Game.Squares[i][yCurrent] == nil then Moves[i][yCurrent] = true
      elseif CC.Game.Squares[i][yCurrent] ~= nil and CC.Pieces[CC.Game.Squares[i][yCurrent]].color ~= color and CC.Pieces[CC.Game.Squares[i][yCurrent]].type ~= CC.Const.king then
        Moves[i][yCurrent] = true
        break
      else
        break
      end
    end
    -- positive y direction
    for i=yCurrent+1, 8, 1 do
      if CC.Game.Squares[xCurrent][i] == nil then Moves[xCurrent][i] = true
      elseif CC.Game.Squares[xCurrent][i] ~= nil and CC.Pieces[CC.Game.Squares[xCurrent][i]].color ~= color and CC.Pieces[CC.Game.Squares[xCurrent][i]].type ~= CC.Const.king then
        Moves[xCurrent][i] = true
        break
      else
        break
      end
    end
    -- negative y direction
    for i=yCurrent-1, 1, -1 do
      if CC.Game.Squares[xCurrent][i] == nil then Moves[xCurrent][i] = true
      elseif CC.Game.Squares[xCurrent][i] ~= nil and CC.Pieces[CC.Game.Squares[xCurrent][i]].color ~= color and CC.Pieces[CC.Game.Squares[xCurrent][i]].type ~= CC.Const.king then
        Moves[xCurrent][i] = true
        break
      else
        break
      end
    end
    -- positive x and y
    local j = 1
    for i=xCurrent+1, 8, 1 do
      if (CC.Game.Squares[i][yCurrent + j] == nil) and ((yCurrent + j) <= 8) then
        Moves[i][yCurrent + j] = true
      elseif CC.Game.Squares[i][yCurrent + j] ~= nil and ((yCurrent + j) <= 8) and CC.Pieces[CC.Game.Squares[i][yCurrent + j]].color ~= color and CC.Pieces[CC.Game.Squares[i][yCurrent + j]].type ~= CC.Const.king then
        Moves[i][yCurrent + j] = true
        break
      else
        break
      end
      j = j + 1
    end
    -- positive x and negative y
    j = 1
    for i=xCurrent+1, 8, 1 do
      if (CC.Game.Squares[i][yCurrent - j] == nil) and ((yCurrent - j) <= 8) then
        Moves[i][yCurrent - j] = true
      elseif CC.Game.Squares[i][yCurrent - j] ~= nil and ((yCurrent - j) <= 8) and CC.Pieces[CC.Game.Squares[i][yCurrent - j]].color ~= color and CC.Pieces[CC.Game.Squares[i][yCurrent - j]].type ~= CC.Const.king then
        Moves[i][yCurrent - j] = true
        break
      else
        break
      end
      j = j + 1
    end
    -- negative x and positive y
    j = 1
    for i=xCurrent-1, 1, -1 do
      if (CC.Game.Squares[i][yCurrent + j] == nil) and ((yCurrent + j) <= 8) then
        Moves[i][yCurrent + j] = true
      elseif CC.Game.Squares[i][yCurrent + j] ~= nil and ((yCurrent + j) <= 8) and CC.Pieces[CC.Game.Squares[i][yCurrent + j]].color ~= color and CC.Pieces[CC.Game.Squares[i][yCurrent + j]].type ~= CC.Const.king then
        Moves[i][yCurrent + j] = true
        break
      else
        break
      end
      j = j + 1
    end
    -- negative x and y
    j = 1
    for i=xCurrent-1, 1, -1 do
      if (CC.Game.Squares[i][yCurrent - j] == nil) and ((yCurrent - j) <= 8) then
        Moves[i][yCurrent - j] = true
      elseif CC.Game.Squares[i][yCurrent - j] ~= nil and ((yCurrent - j) <= 8) and CC.Pieces[CC.Game.Squares[i][yCurrent - j]].color ~= color and CC.Pieces[CC.Game.Squares[i][yCurrent - j]].type ~= CC.Const.king then
        Moves[i][yCurrent - j] = true
        break
      else
        break
      end
      j = j + 1
    end

    --[[ King movement logic
    -- Can only move 1 space in any direction. Can't jump over other pieces.
    -- Captures on the squares it lands on. ]]--
  elseif type == CC.Const.king then    
    if (xCurrent + 1) <= 8 then Moves[xCurrent + 1][yCurrent] = true end
    if (xCurrent - 1) >= 1 then Moves[xCurrent - 1][yCurrent] = true end
    if (yCurrent + 1) <= 8 then Moves[xCurrent][yCurrent + 1] = true end
    if (yCurrent - 1) >= 1 then Moves[xCurrent][yCurrent - 1] = true end
    if ((xCurrent + 1) <= 8) and ((yCurrent + 1) <= 8) then Moves[xCurrent + 1][yCurrent + 1] = true end
    if ((xCurrent + 1) <= 8) and ((yCurrent - 1) >= 1) then Moves[xCurrent + 1][yCurrent - 1] = true end
    if ((xCurrent - 1) >= 1) and ((yCurrent + 1) <= 8) then Moves[xCurrent - 1][yCurrent + 1] = true end
    if ((xCurrent - 1) >= 1) and ((yCurrent - 1) >= 1) then Moves[xCurrent - 1][yCurrent - 1] = true end
  end
  --d(Moves)
  return Moves
end

function CC.Game.Reset(step)
  if step == 0 then
    CC_DialogueBoxDescription:SetText("This will reset all of the game pieces to their original squares. Are you sure you want to continue?")
    CC_DialogueBox:SetHidden(false)
    CC.Que.step = 1
    CC.Que.Callback = CC.Game.Reset
  elseif step == 1 then
    for i,v in pairs(CC.Pieces) do
      local x, worldY, y = HousingEditorGetFurnitureWorldPosition(v.ID)
      HousingEditorRequestChangePosition(v.ID, CC.Board.Grid[v.startX][v.startY].x, worldY, CC.Board.Grid[v.startX][v.startY].y)
    end
    CC.Que.step = 0
    CC.Que.Callback = nil
    CC.Prison.White.Next = {x = 1, y = 1}
    CC.Prison.Black.Next = {x = 1, y = 1}
    CC.Game.Squares = CC.Defaults.Squares
    CC.Pieces = CC.Defaults.Pieces
    for i,v in pairs(CC.SavedVars.PieceIDs) do
      CC.Pieces[i].ID = v.ID
      CC.Pieces[i].name = v.name
    end
    CC_DialogueBox:SetHidden(true)
  end
end

function CC.Game.New(step)
  HousingEditorRequestModeChange(2)
  local worldX, worldY, worldZ, rotationRadians
  if step == 0 then
    CC_DialogueBox:SetHidden(false)
    CC_DialogueBoxDescription:SetText("Please move your character to the outer corner of the White QUEEN'S SIDE Rook square and then press Accept.")
    CC.Que.step = 1
    CC.Que.Callback = CC.Game.New
    return
  elseif step == 1 then
    worldX, worldY, worldZ, rotationRadians = GetPlayerWorldPositionInHouse()
    --CC.Board.Init.Coords = {x1 = worldX, y1 = worldZ}
    CC.Board.Init.Coords = {x1 = 82356, y1 = 94026}
    CC_DialogueBoxDescription:SetText("Please move your character to the outer corner of the White KING'S SIDE Rook square and then press Accept.")
    CC.Que.step = 2
    return
  elseif step == 2 then
    worldX, worldY, worldZ, rotationRadians = GetPlayerWorldPositionInHouse()
    --CC.Board.Init.Coords.x2 = worldX
    --CC.Board.Init.Coords.y2 = worldZ
    CC.Board.Init.Coords.x2 = 86219
    CC.Board.Init.Coords.y2 = 94036
    local x1 = CC.Board.Init.Coords.x1
    local y1 = CC.Board.Init.Coords.y1
    local x2 = CC.Board.Init.Coords.x2
    local y2 = CC.Board.Init.Coords.y2
    CC.Board.Init.length = math.sqrt(math.pow((x2 - x1), 2) + math.pow((y2 - y1), 2))
    CC.Board.Init.squareSize = CC.Board.Init.length / 8
    local squareSize = CC.Board.Init.squareSize
    CC.Board.Init.rotationAngle = math.atan2((y2 - y1), (x2 - x1)) - math.pi
    local rotationAngle = CC.Board.Init.rotationAngle
    --d(CC.Board.Init)
    -- Create game board with appropriately sized squares and coordinates for the center of each square. Also creates extra squares for use in the prison system.
    local Coords = {}
    for i=-1, 10 do
      Coords[i] = {}
      for j=1, 8 do
        Coords[i][j] = {
          x = ((i * squareSize) - (squareSize / 2)) * -1,
          y = (j * squareSize) - (squareSize / 2)
        }
      end
    end
    -- Rotate the board to match the rotation in game
    for i=-1, 10 do
      for j=1, 8 do
        local x = Coords[i][j].x
        local y = Coords[i][j].y
        Coords[i][j].x = (x * math.cos(rotationAngle)) - (y * math.sin(rotationAngle))
        Coords[i][j].y = (x * math.sin(rotationAngle)) + (y * math.cos(rotationAngle))
      end
    end
    -- Move the board to match the in game version
    for i=-1, 10 do
      for j=1, 8 do
        Coords[i][j].x = Coords[i][j].x + x1
        Coords[i][j].y = Coords[i][j].y + y1
      end
    end
    CC.Board.Grid = Coords
    CC.SavedVars.Grid = Coords
    CC.Game.PrisonSetup()
    CC.SavedVars.Prison = CC.Prison
    CC.SavedVars.boardSetup = true
    --d(Coords)
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the White Queen's Side Rook and then press Acept.")
    CC.Que.step = 3
    return
  elseif step == 3 then
    CC.SavedVars.PieceIDs.WQR = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.WQR.name .. " selected as the White Queen's Side Rook.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the White Queen's Side Knight and then press Acept.")
    CC.Que.step = 4
    return
  elseif step == 4 then
    CC.SavedVars.PieceIDs.WQN = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.WQN.name .. " selected as the White Queen's Side Knight.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the White Queen's Side Bishop and then press Acept.")
    CC.Que.step = 5
    return
  elseif step == 5 then
    CC.SavedVars.PieceIDs.WQB = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.WQB.name .. " selected as the White Queen's Side Bishop.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the White Queen and then press Acept.")
    CC.Que.step = 6
    return
  elseif step == 6 then
    CC.SavedVars.PieceIDs.WQ = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.WQ.name .. " selected as the White Queen.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the White King and then press Acept.")
    CC.Que.step = 7
    return
  elseif step == 7 then
    CC.SavedVars.PieceIDs.WK = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.WK.name .. " selected as the White King.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the White King's Side Bishop and then press Acept.")
    CC.Que.step = 8
    return
  elseif step == 8 then
    CC.SavedVars.PieceIDs.WKB = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.WKB.name .. " selected as the White King's Side Bishop.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the White King's Side Knight and then press Acept.")
    CC.Que.step = 9
    return
  elseif step == 9 then
    CC.SavedVars.PieceIDs.WKN = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.WKN.name .. " selected as the White King's Side Knight.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the White King's Side Rook and then press Acept.")
    CC.Que.step = 10
    return
  elseif step == 10 then
    CC.SavedVars.PieceIDs.WKR = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.WKR.name .. " selected as the White King's Side Rook.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the White Pawn 1 and then press Acept.")
    CC.Que.step = 11
    return
  elseif step == 11 then
    CC.SavedVars.PieceIDs.WP1 = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.WP1.name .. " selected as the White Pawn 1.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the White Pawn 2 and then press Acept.")
    CC.Que.step = 12
    return
  elseif step == 12 then
    CC.SavedVars.PieceIDs.WP2 = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.WP2.name .. " selected as the White Pawn 2.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the White Pawn 3 and then press Acept.")
    CC.Que.step = 13
    return
  elseif step == 13 then
    CC.SavedVars.PieceIDs.WP3 = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.WP3.name .. " selected as the White Pawn 3.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the White Pawn 4 and then press Acept.")
    CC.Que.step = 14
    return
  elseif step == 14 then
    CC.SavedVars.PieceIDs.WP4 = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.WP4.name .. " selected as the White Pawn 4.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the White Pawn 5 and then press Acept.")
    CC.Que.step = 15
    return
  elseif step == 15 then
    CC.SavedVars.PieceIDs.WP5 = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.WP5.name .. " selected as the White Pawn 5.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the White Pawn 6 and then press Acept.")
    CC.Que.step = 16
    return
  elseif step == 16 then
    CC.SavedVars.PieceIDs.WP6 = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.WP6.name .. " selected as the White Pawn 6.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the White Pawn 7 and then press Acept.")
    CC.Que.step = 17
    return
  elseif step == 17 then
    CC.SavedVars.PieceIDs.WP7 = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.WP7.name .. " selected as the White Pawn 7.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the White Pawn 8 and then press Acept.")
    CC.Que.step = 18
    return
  elseif step == 18 then
    CC.SavedVars.PieceIDs.WP8 = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.WP8.name .. " selected as the White Pawn 8.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the Black Queen's Side Rook and then press Acept.")
    CC.Que.step = 19
    return
  elseif step == 19 then
    CC.SavedVars.PieceIDs.BQR = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.BQR.name .. " selected as the Black Queen's Side Rook.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the Black Queen's Side Knight and then press Acept.")
    CC.Que.step = 20
    return
  elseif step == 20 then
    CC.SavedVars.PieceIDs.BQN = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.BQN.name .. " selected as the Black Queen's Side Knight.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the Black Queen's Side Bishop and then press Acept.")
    CC.Que.step = 21
    return
  elseif step == 21 then
    CC.SavedVars.PieceIDs.BQB = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.BQB.name .. " selected as the Black Queen's Side Bishop.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the Black Queen and then press Acept.")
    CC.Que.step = 22
    return
  elseif step == 22 then
    CC.SavedVars.PieceIDs.BQ = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.BQ.name .. " selected as the Black Queen.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the Black King and then press Acept.")
    CC.Que.step = 23
    return
  elseif step == 23 then
    CC.SavedVars.PieceIDs.BK = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.BK.name .. " selected as the Black King.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the Black King's Side Bishop and then press Acept.")
    CC.Que.step = 24
    return
  elseif step == 24 then
    CC.SavedVars.PieceIDs.BKB = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.BKB.name .. " selected as the Black King's Side Bishop.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the Black King's Side Knight and then press Acept.")
    CC.Que.step = 25
    return
  elseif step == 25 then
    CC.SavedVars.PieceIDs.BKN = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.BKN.name .. " selected as the Black King's Side Knight.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the Black King's Side Rook and then press Acept.")
    CC.Que.step = 26
    return
  elseif step == 26 then
    CC.SavedVars.PieceIDs.BKR = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.BKR.name .. " selected as the Black King's Side Rook.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the Black Pawn 1 and then press Acept.")
    CC.Que.step = 27
    return
  elseif step == 27 then
    CC.SavedVars.PieceIDs.BP1 = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.BP1.name .. " selected as the Black Pawn 1.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the Black Pawn 2 and then press Acept.")
    CC.Que.step = 28
    return
  elseif step == 28 then
    CC.SavedVars.PieceIDs.BP2 = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.BP2.name .. " selected as the Black Pawn 2.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the Black Pawn 3 and then press Acept.")
    CC.Que.step = 29
    return
  elseif step == 29 then
    CC.SavedVars.PieceIDs.BP3 = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.BP3.name .. " selected as the Black Pawn 3.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the Black Pawn 4 and then press Acept.")
    CC.Que.step = 30
    return
  elseif step == 30 then
    CC.SavedVars.PieceIDs.BP4 = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.BP4.name .. " selected as the Black Pawn 4.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the Black Pawn 5 and then press Acept.")
    CC.Que.step = 31
    return
  elseif step == 31 then
    CC.SavedVars.PieceIDs.BP5 = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.BP5.name .. " selected as the Black Pawn 5.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the Black Pawn 6 and then press Acept.")
    CC.Que.step = 32
    return
  elseif step == 32 then
    CC.SavedVars.PieceIDs.BP6 = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.BP6.name .. " selected as the Black Pawn 6.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the Black Pawn 7 and then press Acept.")
    CC.Que.step = 33
    return
  elseif step == 33 then
    CC.SavedVars.PieceIDs.BP7 = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.BP7.name .. " selected as the Black Pawn 7.")
    CC_DialogueBoxDescription:SetText("Please point your reticule at the furniture item representing the Black Pawn 8 and then press Acept.")
    CC.Que.step = 34
    return
  elseif step == 34 then
    CC.SavedVars.PieceIDs.BP8 = CC.GetPieceFurnitureInfo()
    CC.SendToChat(CC.SavedVars.PieceIDs.BP8.name .. " selected as the Black Pawn 8.")
    CC_DialogueBox:SetHidden(true)
    CC.Que.step = 0
    CC.Que.Callback = nil
    for i,v in pairs(CC.SavedVars.PieceIDs) do
      CC.Pieces[i].ID = v.ID
      CC.Pieces[i].name = v.name
    end
    CC.SavedVars.piecesSetup = true
  end
end

function CC.Game.PrisonSetup()
  -- Setup Black Prison (White pieces go here when captured)
  CC.Prison.Black.Next = {x = 1, y = 1}
  for i=-1, 0 do
    CC.Prison.Black[i+2] = {}
    for j=1, 8 do
      CC.Prison.Black[i+2][j] = {x = CC.Board.Grid[i][j].x, y = CC.Board.Grid[i][j].y}
    end
  end

  -- Setup White Prison (Black pieces go here when captured)
  CC.Prison.White.Next = {x = 1, y = 1}
  for i=9, 10 do
    CC.Prison.White[i-8] = {}
    for j=1, 8 do
      CC.Prison.White[i-8][j] = {x = CC.Board.Grid[i][j].x, y = CC.Board.Grid[i][j].y}
    end
  end
  -- Remove extra spaces from original grid
  CC.Board.Grid[-1] = nil
  CC.Board.Grid[0] = nil
  CC.Board.Grid[9] = nil
  CC.Board.Grid[10] = nil

  --d(CC.Prison)
end

function CC.Game.Capture(piece)
  local x, worldY, y = HousingEditorGetFurnitureWorldPosition(CC.Pieces[piece].ID)
  if CC.Pieces[piece].color == CC.Const.white then
    local next = CC.Prison.Black.Next
    HousingEditorRequestChangePosition(CC.Pieces[piece].ID, CC.Prison.Black[next.x][next.y].x, worldY, CC.Prison.Black[next.x][next.y].y)
    next.y = next.y + 1
    if next.y > 8 then
      next.x = next.x + 1
      next.y = 1
    end
    CC.Prison.Black.Next = {x = next.x, y = next.y}
  elseif CC.Pieces[piece].color == CC.Const.black then
    local next = CC.Prison.White.Next
    HousingEditorRequestChangePosition(CC.Pieces[piece].ID, CC.Prison.White[next.x][next.y].x, worldY, CC.Prison.White[next.x][next.y].y)
    next.y = next.y + 1
    if next.y > 8 then
      next.x = next.x + 1
      next.y = 1
    end
    CC.Prison.White.Next = {x = next.x, y = next.y}
  end
  CC.Game.Squares[CC.Pieces[piece].x][CC.Pieces[piece].y] = nil
  CC.Pieces[piece].x = nil
  CC.Pieces[piece].y = nil
  CC.Pieces[piece].captured = true
end


--[[----------------------------------------------
Command Parser
----------------------------------------------]]--
function CC.CommandParse(args)
	local Options = {}
	for match in (args .. " "):gmatch("(.-)" .. " ") do
    table.insert(Options, match);
  end

	if #Options == 0 then
		--command list
	elseif Options[1] == "new" then
    CC.SendToChat("Board setup started. Follow the on screen instructions to continue.")
    CC.Game.New(0)
  elseif Options[1] == "move" then
    local dest = {x = tonumber(Options[3]), y = tonumber(Options[4])}
    local override = false
    if (Options[5] == "true") or (Options[5] == "1") then override = true end
    CC.Game.Move(Options[2], dest, override)
  elseif Options[1] == "capture" then
    CC.Game.Capture(Options[2])
  elseif Options[1] == "reset" then
    CC.Game.Reset(0)
  elseif Options[1] == "debug" then
    CC.Debug()
  elseif Options[1] == "test" then
    CC.Test(Options[2])
  else
    CC.SendToChat("Invalid command.")
  end
end


--[[----------------------------------------------
UI Buttons
----------------------------------------------]]--
function CC_ACCEPT()
  CC.Que.Callback(CC.Que.step)
end

function CC_CANCEL()
  CC.Que.step = 0
  CC.Que.Callback = nil
  CC_DialogueBox:SetHidden(true)
end


--[[----------------------------------------------
Initialization and Event Callbacks
----------------------------------------------]]--
function CC.OnChatMessageChannel(event, channelType, fromName, messageText, isCustomerService, fromDisplayName)
  if channelType == CHAT_CHANNEL_ZONE or channelType == CHAT_CHANNEL_PARTY then
    piece, x, y = string.match(messageText, "(..?.?)%s+to%s+(%a)(%d)")
    --CC.SendToChat("piece: " .. piece .. ", x: " .. x .. ", y: " .. y)
    if piece ~= nil and x ~= nil and y ~= nil then
      --CC.SendToChat("piece: " .. piece .. ", x: " .. x .. ", y: " .. y)
      local dest = {x = CC.Const[x], y = tonumber(y)}
      CC.Game.Move(piece, dest)
    end
  end
end

function CC.HUDSceneChange(oldState, newState)
  if (newState == SCENE_SHOWN) then
    CC_HUD:SetHidden(false)
  elseif (newState == SCENE_HIDDEN) then
    CC_HUD:SetHidden(true)
  end
end
function CC.HUDUISceneChange(oldState, newState)
  if (newState == SCENE_SHOWN) then
    CC_HUD:SetHidden(false)
  elseif (newState == SCENE_HIDDEN) then
    CC_HUD:SetHidden(true)
  end
end

function CC.Initialize()
  CC.SavedVars = ZO_SavedVars:NewAccountWide("CCGlobalVars", CC.varsVersion, nil, CC.Defaults)	-- Load saved variables

  CC.Pieces = CC.Defaults.Pieces
  CC.Game.Squares = CC.Defaults.Squares
  if CC.SavedVars.boardSetup then
    CC.Board.Grid = CC.SavedVars.Grid
    CC.Prison = CC.SavedVars.Prison
  end
  if CC.SavedVars.piecesSetup then
    for i,v in pairs(CC.SavedVars.PieceIDs) do
      CC.Pieces[i].ID = v.ID
      CC.Pieces[i].name = v.name
    end
  end

  local scene = SM:GetScene("hud")
  scene:RegisterCallback("StateChange", CC.HUDSceneChange)
  local scene = SM:GetScene("hudui")
  scene:RegisterCallback("StateChange", CC.HUDUISceneChange)

  EM:RegisterForEvent(CC.addonName, EVENT_CHAT_MESSAGE_CHANNEL, CC.OnChatMessageChannel)
  EM:UnregisterForEvent(CC.addonName, EVENT_ADD_ON_LOADED)  
end

function CC.OnAddonLoaded(eventCode, addonName)
  if addonName == CC.addonName then
    CC.Initialize()
  end
end


--[[----------------------------------------------
Main Registration
----------------------------------------------]]--
SLASH_COMMANDS["/cc"] = CC.CommandParse
EM:RegisterForEvent(CC.addonName, EVENT_ADD_ON_LOADED, CC.OnAddonLoaded)